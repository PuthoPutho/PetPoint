class QuizChoice {
  final String id;
  final String text;
  final bool isCorrect;

  QuizChoice({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  // 🌟 ฟังก์ชันแปลง JSON สำหรับตัวเลือก (Choice)
  factory QuizChoice.fromJson(Map<String, dynamic> json) {
    return QuizChoice(
      id: json['uuid']?.toString() ?? json['id']?.toString() ?? '', 
      text: json['choices'] ?? json['text'] ?? json['choiceText'] ?? '',
      isCorrect: json['isCorrect'] ?? json['is_correct'] ?? false,
    );
  }
}

class QuizQuestion {
  final String id;
  final String question;
  final List<QuizChoice> choices;
  final String explanation;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.choices,
    required this.explanation,
  });

// 🌟 ฟังก์ชันแปลง JSON สำหรับคำถาม (Question) ที่ Error แจ้งว่าหาไม่เจอ
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    var choicesList = json['choices'] as List? ?? [];
    return QuizQuestion(
      id: json['uuid']?.toString() ?? json['id']?.toString() ?? '',
      question: json['question'] ?? json['text'] ?? '',
      choices: choicesList.map((c) => QuizChoice.fromJson(c)).toList(),
      explanation: json['explanation'] ?? '',
    );
  }
  
}