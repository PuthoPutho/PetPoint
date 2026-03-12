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

}
