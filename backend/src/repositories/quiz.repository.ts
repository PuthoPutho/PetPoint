import { eq, and, desc, sql, inArray, getTableColumns } from 'drizzle-orm';
import { db } from '../db/index.js';
import { user, quiz_attempts, quiz, questions, choices, quiz_history } from '../db/schema.js';


export const quizRepository = {
    // 1. ฟังก์ชันดึงประวัติการทำควิซ "รอบล่าสุด" ของผู้ใช้ (เพื่อเอาไปหาคะแนนส่วนต่าง)
    getLatestAttempt: async (userId: string, quizId: string) => {
        const attempts = await db.select()
            .from(quiz_attempts)
            .where(
                and(
                    eq(quiz_attempts.userId, userId),
                    eq(quiz_attempts.quizId, quizId)
                )
            )
            .orderBy(desc(quiz_attempts.createdAt)) // เรียงจากใหม่ไปเก่า
            .limit(1); // ดึงมาแค่รอบล่าสุดรอบเดียว

        return attempts.length > 0 ? attempts[0] : null;
    },

    // 2. ฟังก์ชันบันทึกประวัติการทำควิซ "รอบใหม่" ลง Database
    saveAttempt: async (userId: string, quizId: string, score: number) => {
        const [newAttempt] = await db.insert(quiz_attempts)
            .values({
                userId,
                quizId,
                score,
            })
            .returning(); // .returning() คือขอข้อมูลที่เพิ่ง insert กลับมาดูด้วย

        return newAttempt;
    },

    // 3. ฟังก์ชันอัปเดตแต้ม (รองรับทั้งบวกและลบ)
    updateTotalScore: async (userId: string, delta: number) => {
        const [updatedUser] = await db.update(user)
            .set({
                // ถ้า delta เป็นบวก มันจะบวกเพิ่ม / ถ้า delta เป็นลบ มันจะหักออก
                // และ GREATEST(0, ...) จะช่วยให้แต้มไม่ต่ำกว่า 0
                currentScore: sql`GREATEST(0, ${user.currentScore} + ${delta})`
            })
            .where(eq(user.uuid, userId))
            .returning({
                currentScore: user.currentScore
            });
        return updatedUser;
    },
    // 3.1 บันทึกรายละเอียดการตอบแต่ละข้อ
    saveQuizHistory: async (attemptId: string, userId: string, detailedAnswers: any[]) => {
        return await db.insert(quiz_history).values(
            detailedAnswers.map(ans => ({
                attemptId,
                userId,
                questionId: ans.questionId,
                choiceId: ans.choiceId,
                isCorrect: ans.isCorrect
            }))
        );
    },

    // 4. ดึงรายชื่อควิซ "ทั้งหมด" (เอาไปทำหน้าเมนู)
    getAllQuizzes: async () => {
        return await db.select({
            ...getTableColumns(quiz), // ดึงคอลัมน์เดิมมาให้ครบ (title, image, duration ฯลฯ)
            questionCount: sql<number>`cast(count(${questions.uuid}) as int)` // แอบนับจำนวนข้อให้
        })
            .from(quiz)
            .leftJoin(questions, eq(quiz.uuid, questions.quizId))
            .groupBy(quiz.uuid);
    },

    // 4.1 ใช้สำหรับหน้า Quiz Details ก่อนกดเข้าห้องสอบ (นับจำนวนข้อ + เช็คว่าเคยทำหรือยัง)
    getQuizDetailsForUser: async (userId: string, quizId: string) => {
        // 1. ดึงรายละเอียดควิซและนับจำนวนข้อ
        const [quizDetails] = await db.select({
            ...getTableColumns(quiz),
            questionCount: sql<number>`cast(count(${questions.uuid}) as int)`
        })
            .from(quiz)
            .leftJoin(questions, eq(quiz.uuid, questions.quizId))
            .where(eq(quiz.uuid, quizId))
            .groupBy(quiz.uuid);

        if (!quizDetails) return null;

        // 2. แอบดูประวัติว่า User คนนี้เคยทำควิซนี้ไปหรือยัง (เอาไว้ทำปุ่ม Reattempt)
        const attempts = await db.select()
            .from(quiz_attempts)
            .where(
                and(
                    eq(quiz_attempts.userId, userId),
                    eq(quiz_attempts.quizId, quizId)
                )
            )
            .orderBy(desc(quiz_attempts.createdAt))
            .limit(1);

        const lastAttempt = attempts.length > 0 ? attempts[0] : null;

        // 3. แพ็ครวมส่งให้ Flutter
        return {
            ...quizDetails,
            isCompleted: !!lastAttempt, // ถ้าเคยทำแล้วเป็น true (ให้ Flutter โชว์ปุ่ม Reattempt)
            lastScore: lastAttempt ? lastAttempt.score : null // โชว์คะแนนรอบล่าสุด
        };
    },

    // 5. ดึงข้อมูลควิซ "1 หมวด" พร้อมคำถามและช้อยส์ทั้งหมด
    getQuizWithQuestionsAndChoices: async (quizId: string) => {
        // 5.1 หาข้อมูลหัวข้อควิซ
        const [quizData] = await db.select().from(quiz).where(eq(quiz.uuid, quizId));
        if (!quizData) return null; // ถ้าไม่เจอให้คืนค่า null

        // 5.2 หาคำถามทั้งหมดที่อยู่ในควิซนี้
        const allQuestions = await db.select().from(questions).where(eq(questions.quizId, quizId));

        // 5.3 หาช้อยส์ทั้งหมดของคำถามเซ็ตนี้
        let allChoices: any[] = [];
        if (allQuestions.length > 0) {
            const questionIds = allQuestions.map(q => q.uuid); // ดึงมาแค่รหัสคำถาม
            allChoices = await db.select()
                .from(choices)
                .where(inArray(choices.questionId, questionIds));
        }

        // 🌟 5.4 พระเอก: รวมร่างให้ช้อยส์เข้าไปอยู่ในแต่ละข้อคำถาม
        const formattedQuestions = allQuestions.map(q => {
            return {
                ...q,
                // กรองเอาเฉพาะช้อยส์ที่คำถามตัวนี้เป็นเจ้าของ
                choices: allChoices.filter(c => c.questionId === q.uuid)
            };
        });

        // คืนค่ากลับไปให้ Service เป็นก้อนเดียวกัน
        return {
            ...quizData,
            questions: formattedQuestions
        };
    },

    // 6. ดึงประวัติการสอบทั้งหมด (เรียงจากล่าสุดไปเก่าสุด)
    getUserHistory: async (userId: string) => {
        return await db.select({
            id: quiz_attempts.uuid,
            quizId: quiz.uuid,
            quizTitle: quiz.title,
            category: quiz.category,
            score: quiz_attempts.score,
            createdAt: quiz_attempts.createdAt
        })
            .from(quiz_attempts)
            .innerJoin(quiz, eq(quiz_attempts.quizId, quiz.uuid))
            .where(eq(quiz_attempts.userId, userId))
            .orderBy(desc(quiz_attempts.createdAt));
    },

    // 7. ดึงคะแนน "ล่าสุด" ของแต่ละ QuizId เพื่อไปทำ Spider Chart
    getLatestScoresByCategory: async (userId: string) => {
        // ใช้ selectDistinctOn เพื่อดึงเฉพาะแถวที่ใหม่ที่สุดของแต่ละ quizId
        return await db.selectDistinctOn([quiz_attempts.quizId], {
            category: quiz.category,
            quizId: quiz_attempts.quizId,
            score: quiz_attempts.score,
            createdAt: quiz_attempts.createdAt
        })
            .from(quiz_attempts)
            .innerJoin(quiz, eq(quiz_attempts.quizId, quiz.uuid))
            .where(eq(quiz_attempts.userId, userId))
            .orderBy(quiz_attempts.quizId, desc(quiz_attempts.createdAt));
    }
};