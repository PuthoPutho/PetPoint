import { Router } from 'express';
import { QuestionService } from '../services/question.service.js';
import { UUID } from 'node:crypto';

const router = Router();
const service = new QuestionService();

router.get('/', async (req, res) => {
    try {
        const questions = await service.getAllQuestions();
        res.json(questions);
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
});

router.get('/:id', async (req, res) => {
    try {
        const question = await service.getQuestionById(req.params.id as UUID);
        if (!question) return res.status(404).json({ error: 'Question not found' });
        res.json(question);
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
});

export default router;
