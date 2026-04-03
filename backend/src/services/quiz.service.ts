import { quizRepository } from '../repositories/quiz.repository.js';

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

            // 2. ดึงคะแนน "ล่าสุด" เพื่อหาส่วนต่าง
            const latestAttempt = await quizRepository.getLatestAttempt(userId, quizId);
            const oldScore = latestAttempt ? latestAttempt.score : 0;
            const delta = newScore - oldScore;

            // 3. บันทึกประวัติการสอบรอบนี้ (ตาราง quiz_attempts)
            const newAttempt = await quizRepository.saveAttempt(userId, quizId, newScore);

            // 4. บันทึกรายละเอียดการตอบรายข้อ (ตาราง quiz_history)
            if (newAttempt) {
                await quizRepository.saveQuizHistory(newAttempt.uuid, userId, detailedAnswers);
            }

            // 5. อัปเดตแต้มรวม (เรียกใช้จาก quizRepository ตามที่คุณแก้มา)
            const updatedUser = await quizRepository.updateTotalScore(userId, delta);

            return {
                success: true,
                message: delta >= 0 ? "คะแนนดีขึ้นหรือเท่าเดิม!" : "คะแนนลดลงจากครั้งก่อนนะ",
                scoreObtained: newScore,
                pointsChanged: delta,
                currentTotalScore: updatedUser?.currentScore || 0
            };
        } catch (error) {
            console.error("Submit Quiz Error:", error);
            throw error;
        }
    },

    // --- ส่วนอื่นๆ (GET ทั้งหมด) เหมือนเดิม---
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

            // แยก questions ออกจากฟีลด์อื่นๆ ของ data
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

    getSpiderChartData: async (userId: string) => {
        try {
            const latestScores = await quizRepository.getLatestScoresByCategory(userId);
            const categories = ["Vocabulary", "Grammar", "Conversation", "Sentence", "Reading"];
            const spiderMap: Record<string, number> = {};
            categories.forEach(cat => spiderMap[cat] = 0);

            latestScores.forEach(item => {
                if (spiderMap[item.category] !== undefined) {
                    spiderMap[item.category] += Number(item.score);
                }
            });

            const formattedData = Object.keys(spiderMap).map(key => ({
                subject: key,
                score: spiderMap[key],  
                fullMark: 20
            }));

            return { success: true, data: formattedData };
        } catch (error) {
            throw new Error("คำนวณข้อมูลกราฟไม่สำเร็จ");
        }
    }
};
