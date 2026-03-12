import { randomUUID, UUID } from 'node:crypto';
import { db } from '../db/index.js';
import { questions, choices } from '../db/schema.js';
import { eq } from 'drizzle-orm';

export class QuestionRepository {
    async getAllQuestions() {
        return await db.query.questions.findMany({
            with: {
                choices: true,
            },
        });
    }

    async getQuestionById(id: UUID) {
        return await db.query.questions.findFirst({
            where: eq(questions.uuid, id),
            with: {
                choices: true,
            },
        });
    }

    async createQuestion(question: string, category: string, level: string) {
        const result = await db.insert(questions).values({ question, category, level }).returning();
        return result[0];
    }

    async createChoice(answer: string, isCorrect: boolean, questionId: UUID) {
        const result = await db.insert(choices).values({ answer, isCorrect, questionId }).returning();
        return result[0];
    }
}
