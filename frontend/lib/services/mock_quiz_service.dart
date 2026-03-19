import '../models/quiz.dart';

class MockQuizService {
  static List<Quiz> getMockQuizzes() {
    final now = DateTime.now();
    return [
      Quiz(
        uuid: '1',
        title: 'Basic Vocabulary',
        description: 'Learn common words',
        category: 'Vocabulary',
        points: 10,
        createdAt: now.subtract(const Duration(days: 2)),
        duration: 1, // 10 นาที
  questionCount: 10, // 10 ข้อ
      ),
      Quiz(
        uuid: '2',
        title: 'Present Tense',
        description: 'Grammar rules for present tense',
        category: 'Grammar',
        points: 10,
        createdAt: now.subtract(const Duration(days: 15)),
        duration: 1, // 10 นาที
  questionCount: 10, // 10 ข้อ
      ),
      Quiz(
        uuid: '3',
        title: 'Short Story Reading',
        description: 'Read and answer questions',
        category: 'Reading',
        points: 10,
        createdAt: now.subtract(const Duration(days: 45)),
        duration: 1, // 10 นาที
  questionCount: 10, // 10 ข้อ
      ),
      Quiz(
        uuid: '4',
        title: 'Daily Conversation',
        description: 'Practice speaking situations',
        category: 'Conversation',
        points: 10,
        createdAt: now.subtract(const Duration(days: 5)),
        duration: 1, // 10 นาที
        questionCount: 10, // 10 ข้อ
      ),
      Quiz(
        uuid: '5',
        title: 'Sentence Structure',
        description: 'Building correct sentences',
        category: 'Sentence',
        points: 10,
        createdAt: now.subtract(const Duration(days: 400)),
        duration: 1, // 10 นาที
        questionCount: 10, // 10 ข้อ
      ),
      Quiz(
        uuid: '6',
        title: 'Advanced Vocabulary',
        description: 'Expand your word list',
        category: 'Vocabulary',
        points: 10,
        createdAt: now.subtract(const Duration(days: 20)),
        duration: 1, // 10 นาที
       questionCount: 10, // 10 ข้อ
      ),
    ];
  }
}