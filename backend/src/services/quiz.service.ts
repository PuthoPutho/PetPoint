import { quizRepository } from '../repositories/quiz.repository.js';
import { eq, sql, asc } from 'drizzle-orm';
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

            // 🌟 4. [ส่วนที่แก้ใหม่] อัปเดตคะแนนล่าสุดบวกเพิ่มเข้าไปในสถิติของผู้ใช้เลย (ตามที่คุณต้องการ)
            // เราจะดึงคะแนนเดิมมาบวกกับคะแนนที่เพิ่งทำได้ใหม่
            await db.update(user)
                .set({ 
                    currentScore: sql`${user.currentScore} + ${newScore}` 
                })
                .where(eq(user.uuid, userId));

            // เอาระดับคะแนนรวมล่าสุดหลังบวกเสร็จออกมาเพื่อส่งกลับไปให้ Frontend ด้วย
            const [updatedUser] = await db.select({ totalScore: user.currentScore })
                .from(user)
                .where(eq(user.uuid, userId));
            
            const newTotalScore = updatedUser?.totalScore ?? 0;

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

    getQuizzesList: async (userId?: string) => {
        try {
            // 🌟 ปรับปรุง: ส่ง userId เข้าไปด้วยเพื่อเช็คสถานะการทำสำเร็จ (isCompleted) ของแต่ละผู้ใช้
            const quizzes = await quizRepository.getAllQuizzes(userId);
            return { success: true, data: quizzes };
        } catch (error) {
            console.error("getQuizzesList Error:", error);
            console.error("🚨 Error Database:", error);
            throw new Error("ไม่สามารถดึงข้อมูลควิซได้");
        }
    },

    async getQuizDetails(quizId: string, userId?: string) {
        try {
            // ถ้ามี userId มาด้วย => ให้ไปดึงข้อมูลควิซขยับมาเช็คสถานะการทำ (Completed) ของ User คนนี้ด้วย
            if (userId) {
                const data = await quizRepository.getQuizDetailsForUser(userId, quizId);
                if (!data) return { success: false, message: "ไม่พบควิซ" };
                return { success: true, data };
            }

            // ถ้าไม่มี userId => ดึงแบบควิซปกติ (ใช้สำหรับหน้า Quiz List ทั่วไป)
            const rawData = await quizRepository.getQuizWithQuestionsAndChoices(quizId);
            if (!rawData) return { success: false, message: "ไม่พบควิซ" };

            const { questions, ...quizData } = rawData;
            return {
                success: true,
                data: {
                    ...quizData,
                    questionCount: questions.length
                }
            };
        } catch (error) {
            console.error("getQuizDetails Error:", error);
            throw new Error("ไม่สามารถดึงรายละเอียดควิซได้");
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
            // 🌟 ปรับปรุง: ใช้ getLatestScoresByCategory เพื่อให้ได้คะแนนล่าสุดของแต่ละ Quiz มาทำ Spider Chart
            const latestScores = await quizRepository.getLatestScoresByCategory(userId);

            return {
                success: true,
                data: latestScores
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