class QuizChoice {
  final int id;
  final String text;
  final bool isCorrect;

  QuizChoice({
    required this.id,
    required this.text,
    required this.isCorrect,
  });
}

class QuizQuestion {
  final int id;
  final String question;
  final List<QuizChoice> choices;
  final String explanation;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.choices,
    required this.explanation,
  });
}