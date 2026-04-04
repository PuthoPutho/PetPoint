import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { quizRouter } from './routes/quiz.routes.js';
import { profileRouter } from './routes/profile.routes.js';
import path from 'path';
import fs from 'fs';

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());





app.use('/api/quiz', quizRouter);
app.use('/api/profile', profileRouter);
app.use('/uploads', express.static(path.join(process.cwd(), 'uploads')));


const uploadDir = './uploads';
if (!fs.existsSync(uploadDir)){
    fs.mkdirSync(uploadDir);
    console.log('✅ Created uploads folder automatically');
}

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
