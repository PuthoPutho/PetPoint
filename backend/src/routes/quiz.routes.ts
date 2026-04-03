import { Router } from 'express';
import { quizService } from '../services/quiz.service.js';

export const quizRouter = Router();

// POST /api/quiz/submit
quizRouter.post('/submit', async (req, res) => {
    try {
        const { userId, quizId, answers } = req.body;

        if (!userId || !quizId || !answers) {
            res.status(400).json({ 
                success: false, 
                message: "ส่งข้อมูลมาไม่ครบ (ต้องการ userId, quizId, และ answers)" 
            });
            return;
        }

        const result = await quizService.submitQuiz(userId, quizId, answers);
        res.status(200).json(result);

    } catch (error) {
        console.error("Error in POST /api/quiz/submit:", error);
        res.status(500).json({ 
            success: false, 
            message: "เกิดข้อผิดพลาดที่ระบบหลังบ้าน" 
        });
    }
});

// GET /api/quiz
quizRouter.get('/', async (req, res) => {
    try {
        const result = await quizService.getQuizzesList();
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดที่เซิร์ฟเวอร์" });
    }
});

// GET /api/quiz/:quizId
quizRouter.get('/:quizId', async (req, res) => {
    try {
        const { quizId } = req.params;
        const result = await quizService.getQuizDetails(quizId);
        
        if (!result.success) {
            res.status(404).json(result);
            return;
        }

        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดที่เซิร์ฟเวอร์" });
    }
});


// GET /api/quiz/history/:userId
quizRouter.get('/history/:userId', async (req, res) => {
    try {
        const { userId } = req.params;
        const result = await quizService.getUserQuizHistory(userId);
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ 
            success: false, 
            message: error instanceof Error ? error.message : "เกิดข้อผิดพลาดที่เซิร์ฟเวอร์" 
        });
    }
});

// ดึงข้อมูลกราฟใยแมงมุม
// GET /api/quiz/spider-chart/:userId
quizRouter.get('/spider-chart/:userId', async (req, res) => {
    try {
        const { userId } = req.params;
        const result = await quizService.getSpiderChartData(userId);
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ 
            success: false, 
            message: error instanceof Error ? error.message : "เกิดข้อผิดพลาดที่เซิร์ฟเวอร์" 
        });
    }
});