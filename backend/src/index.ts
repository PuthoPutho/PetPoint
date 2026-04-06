import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
<<<<<<< Updated upstream
import questionRoutes from './routes/question.routes.js';
=======
import { quizRouter } from './routes/quiz.routes.js';
import authRoutes from './routes/auth.routes.js';
>>>>>>> Stashed changes

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.use('/api/questions', questionRoutes);

<<<<<<< Updated upstream
app.get('/health', (req, res) => {
    res.json({ status: 'ok' });
});
=======

app.use('/api/quiz', quizRouter);
app.use('/api/auth', authRoutes);
>>>>>>> Stashed changes

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
