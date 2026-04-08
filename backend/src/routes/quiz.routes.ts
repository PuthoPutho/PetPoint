import { Router } from 'express';
import { quizService } from '../services/quiz.service.js';

const router = Router();

// 1. ดึงควิซทั้งหมด (รองรับ ?userId=... เพื่อเช็คสถานะแต่ละควิซ)
router.get('/', async (req, res) => {
    try {
        const userId = req.query.userId as string | undefined;
        const result = await quizService.getQuizzesList(userId);
        res.json(result);
    } catch (error) {
        res.status(500).json({ success: false, message: (error as Error).message });
    }
});

// 2. ดึงประวัติการสอบของ User
router.get('/history/:userId', async (req, res) => {
    try {
        const result = await quizService.getUserQuizHistory(req.params.userId);
        res.json(result);
    } catch (error) {
        res.status(500).json({ success: false, message: (error as Error).message });
    }
});

// 3. ดึงข้อมูล Spider Chart
router.get('/spider-chart/:userId', async (req, res) => {
    try {
        const result = await quizService.getSpiderChartData(req.params.userId);
        res.json(result);
    } catch (error) {
        res.status(500).json({ success: false, message: (error as Error).message });
    }
});

// 4. ดึงรายละเอียดควิซ (เช็คสถานะ Completed ด้วย)
router.get('/:quizId', async (req, res) => {
    try {
        const userId = req.query.userId as string | undefined;
        const result = await quizService.getQuizDetails(req.params.quizId, userId);
        res.json(result);
    } catch (error) {
        res.status(500).json({ success: false, message: (error as Error).message });
    }
});

// 5. ส่งคำตอบควิซ
router.post('/submit', async (req, res) => {
    try {
        const { userId, quizId, answers } = req.body;
        const result = await quizService.submitQuiz(userId, quizId, answers);
        res.json(result);
    } catch (error) {
        res.status(500).json({ success: false, message: (error as Error).message });
    }
});

// 6. ดึงคำถามทั้งหมดของควิซนั้นๆ
router.get('/:quizId/questions', async (req, res) => {
    try {
        const result = await quizService.getQuizQuestions(req.params.quizId);
        res.json({ success: true, data: result?.questions || [] });
    } catch (error) {
        res.status(500).json({ success: false, message: (error as Error).message });
    }
});

export { router as quizRouter };
