class Quiz {
  final String uuid;
  final String title;
  final String description;
  final String category;
  final int points;
  final int duration; // 👈 เพิ่มเวลาทำควิซ (นาที)
  final int questionCount; // 👈 เพิ่มจำนวนข้อ
  final String level;
  final String tag;
  final DateTime createdAt;

  Quiz({
    required this.uuid,
    required this.title,
    required this.description,
    required this.category,
    required this.points,
    required this.duration,
    required this.questionCount,
    required this.tag,
    required this.createdAt,
    required this.level,
  });
}