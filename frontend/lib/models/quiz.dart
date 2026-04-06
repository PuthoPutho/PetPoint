class Quiz {
  final String uuid;
  final String title;
  final String description;
  final String category;
  final String? level;     // เผื่อมี level (เช่น A1, B2)
  final int points;
  final int duration;      // เวลาทำควิซ (นาที หรือ วินาที)
  final int questionCount; // จำนวนข้อ
  
  //  ฟิลด์ใหม่ที่รับมาจาก Backend เพื่อใช้ทำ UI
  final String? image;       // ลิงก์รูปปกจาก Unsplash
  final bool? isCompleted;   // เช็คว่าเคยทำหรือยัง (เอาไว้โชว์ปุ่ม Reattempt)
  final int? lastScore;      // คะแนนรอบล่าสุด (เอาไว้โชว์ในหน้า Detail)
final String tag;
final DateTime createdAt;
  Quiz({
    required this.uuid,
    required this.title,
    required this.description,
    required this.category,
    this.level,
    required this.points,
    required this.duration,
    required this.questionCount,
    this.image,
    this.isCompleted,
    this.lastScore,
    required this.createdAt,
    required this.tag
  });

  //  ฟังก์ชสำหรับแปลง JSON จาก Backend เป็น Dart Object
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      // รองรับทั้งคีย์ uuid หรือ id (ขึ้นอยู่กับ Backend ส่งอะไรมา)
      uuid: json['uuid'] ?? json['id'] ?? '', 
      title: json['title'] ?? 'Untitled',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      level: json['level'],
      points: json['points'] ?? 0,
      duration: json['duration'] ?? 0,
      questionCount: json['questionCount'] ?? 0,
      tag: json['tag']?.toString() ?? 'General',
      image: json['quizImage'], // ถ้ารูปเป็น null ใน dart ก็จะมองเป็น null
      isCompleted: json['isCompleted'] ?? false, 
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'].toString()) 
          : DateTime.now(), // ถ้าไม่มีให้ใช้วันนี้เป็นค่าเริ่มต้
      lastScore: json['lastScore'],
    );
  }
}