import { UUID } from 'node:crypto';
import { QuestionRepository } from '../repositories/question.repository.js';

export class QuestionService {
    private repository: QuestionRepository;

    constructor() {
        this.repository = new QuestionRepository();
    }

    async getAllQuestions() {
        return this.repository.getAllQuestions();
    }

    async getQuestionById(id: UUID) {
        return this.repository.getQuestionById(id);
    }

    async createQuestion(question: string, category: string, level: string, choices: { answer: string; isCorrect: boolean }[]) {
        const q = await this.repository.createQuestion(question, category, level);
        if (!q) {
            throw new Error('Failed to create question');
        }
        const createdChoices = await Promise.all(
            choices.map((choice) => this.repository.createChoice(choice.answer, choice.isCorrect, q.uuid as UUID))
        );
        return { ...q, choices: createdChoices };
    }
}
