// ไฟล์: src/services/quiz.service.ts
import { quizRepository } from '../repositories/quiz.repository.js';
import { eq } from 'drizzle-orm';
import { db } from '../db/index.js'; 
//  เพิ่มตาราง user เข้ามาใน import ด้วยนะครับ เพื่อเอาไว้อัปเดตคะแนน
import { quiz, quiz_history, quiz_attempts, user } from '../db/schema.js'; 

// 1. ฟังก์ชันช่วยคำนวณคะแนน (Helper Function)
const calculateScore = async (quizId: string, userAnswers: any[]) => {
    const rawData = await quizRepository.getQuizWithQuestionsAndChoices(quizId);
    if (!rawData) return { score: 0, detailedAnswers: [] };

    let score = 0;
    const detailedAnswers = userAnswers.map(ans => {
        // หาข้อคำถามเพื่อไปดูช้อยส์ที่ถูกต้อง
        const question = rawData.questions.find(q => q.uuid === ans.questionId);
        const correctChoice = question?.choices.find(c => (c as any).isCorrect === true);
        
        const isCorrect = correctChoice && (correctChoice as any).uuid === ans.choiceId;
        if (isCorrect) score++;

        return {
            questionId: ans.questionId,
            choiceId: ans.choiceId,
            isCorrect: isCorrect
        };
    });

    return { score, detailedAnswers };
};

export const quizService = {
    submitQuiz: async (userId: string, quizId: string, userAnswers: any[]) => {
        try {
            // 1. คำนวณคะแนนและดึงรายละเอียดรายข้อ
            const { score: newScore, detailedAnswers } = await calculateScore(quizId, userAnswers); 

            // 2. บันทึกประวัติการสอบรอบนี้ 
            const newAttempt = await quizRepository.saveAttempt(userId, quizId, newScore);

            // 3. บันทึกรายละเอียดการตอบรายข้อ 
            if (newAttempt) {
                await quizRepository.saveQuizHistory(newAttempt.uuid, userId, detailedAnswers);
            }

            // 🌟 4. [ส่วนที่แก้ใหม่] ดึงประวัติทั้งหมด "พร้อมหมวดหมู่ (Category)" ของควิซนั้น
            const historyWithCategory = await db.select({
                quizId: quiz_attempts.quizId,
                score: quiz_attempts.score,
                category: quiz.category
            })
            .from(quiz_attempts)
            .innerJoin(quiz, eq(quiz_attempts.quizId, quiz.uuid))
            .where(eq(quiz_attempts.userId, userId));

            // 🌟 5. จัดกลุ่มคะแนนล่าสุดตามหมวดหมู่ (ลอก Logic มาจาก Flutter เป๊ะๆ)
            const latestScores: Record<string, Map<string, number>> = {
                grammar: new Map(),
                vocab: new Map(),
                reading: new Map(),
                sentence: new Map(),
                meaning: new Map()
            };

            historyWithCategory.forEach(attempt => {
                if (!attempt.quizId || !attempt.category) return;
                
                const cat = attempt.category.toLowerCase();
                let mappedCat = '';
                if (cat.includes('grammar')) mappedCat = 'grammar';
                else if (cat.includes('vocab')) mappedCat = 'vocab';
                else if (cat.includes('reading')) mappedCat = 'reading';
                else if (cat.includes('sentence')) mappedCat = 'sentence';
                else if (cat.includes('meaning')) mappedCat = 'meaning';

                if (mappedCat) {
                    // เซฟทับคะแนนเดิมด้วยคะแนนล่าสุด
                    latestScores[mappedCat].set(attempt.quizId, attempt.score ?? 0);
                }
            });

            // 🌟 6. รวมคะแนนแต่ละหมวด และ "จำกัดเพดาน (Clamp) หมวดละ 20" ให้เหมือนกราฟ
            let newTotalScore = 0;
            Object.keys(latestScores).forEach(key => {
                let catSum = 0;
                latestScores[key].forEach(score => { catSum += score; });
                
                // Clamp คะแนนให้อยู่ในช่วง 0 ถึง 20
                if (catSum > 20) catSum = 20;
                if (catSum < 0) catSum = 0;
                
                newTotalScore += catSum; // เอามารวมเป็นคะแนนสุทธิ
            });

            //  7. อัปเดตทับลงตาราง user
            await db.update(user)
                .set({ currentScore: newTotalScore })
                .where(eq(user.uuid, userId));

            return {
                success: true,
                message: "อัปเดตสเตตัสความสามารถล่าสุดเรียบร้อย!",
                scoreObtained: newScore,
                currentTotalScore: newTotalScore
            };
        } catch (error) {
            console.error("Submit Quiz Error:", error);
            throw error;
        }
    },

    getQuizzesList: async () => {
        try {
            const quizzes = await quizRepository.getAllQuizzes();
            return { success: true, data: quizzes };
        } catch (error) {
            throw new Error("ไม่สามารถดึงข้อมูลควิซได้");
        }
    },

    getQuizDetails: async (quizId: string) => {
        try {
            const rawData = await quizRepository.getQuizWithQuestionsAndChoices(quizId);
            if (!rawData) return { success: false, message: "ไม่พบควิซ" };

            const { questions, ...quizData } = rawData;

            const formattedQuiz = {
                ...quizData,
                questions: questions.map(question => ({
                    id: question.uuid,
                    question: (question as any).question,
                    explanation: (question as any).explanation,
                    choices: (question as any).choices.map((c: any) => ({
                        id: c.uuid,
                        text: c.choices,
                        isCorrect: c.isCorrect
                    }))
                }))
            };
            return { success: true, data: formattedQuiz };
        } catch (error) {
            throw new Error("ไม่สามารถดึงข้อมูลคำถามได้");
        }
    },

    getUserQuizHistory: async (userId: string) => {
        try {
            const history = await quizRepository.getUserHistory(userId);
            return { success: true, data: history };
        } catch (error) {
            throw new Error("ดึงประวัติไม่สำเร็จ");
        }
    },

    async getSpiderChartData(userId: string) {
        try {
            const historyWithCategory = await db.select({
                quizId: quiz_attempts.quizId,
                score: quiz_attempts.score,
                category: quiz.category
            })
            .from(quiz_attempts)
            .innerJoin(quiz, eq(quiz_attempts.quizId, quiz.uuid))
            .where(eq(quiz_attempts.userId, userId));

            return {
                success: true,
                data: historyWithCategory
            };
        } catch (error) {
            console.error("Error fetching spider chart data:", error);
            throw new Error("ไม่สามารถดึงข้อมูล Spider Chart ได้");
        }
    },
    
    getQuizQuestions: async (quizId: string) => {
        return await quizRepository.getQuizWithQuestionsAndChoices(quizId);
    }
};