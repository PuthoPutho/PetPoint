import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { quizRouter } from './routes/quiz.routes.js';
import authRoutes from './routes/auth.routes.js';
import { profileRouter } from './routes/profile.routes.js';
import { donationRouter } from './routes/donation.routes.js';
import { shelterRouter } from './routes/shelter.routes.js';



dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());


app.get('/health', (req, res) => {
    res.json({ status: 'ok' });
});


app.use('/api/auth', authRoutes);


app.use('/api/quiz', quizRouter);
app.use('/api/profile', profileRouter);
app.use('/api/donation', donationRouter);
app.use('/api/shelter', shelterRouter);




app.listen(Number(port), '0.0.0.0', () => {
  console.log(`Server is running on port ${port}`);
});