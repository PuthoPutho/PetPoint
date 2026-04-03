import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../screens/quiz/quiz_detail_screen.dart';

class QuizCard extends StatelessWidget {
  final Quiz quizData;

  const QuizCard({super.key, required this.quizData});

  @override
  Widget build(BuildContext context) {
    print('👉 รูปภาพของควิซ ${quizData.title} คือ: ${quizData.image}');
    return Container(
      width: 336,
      height: 218,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        clipBehavior: Clip.antiAlias, // ทำให้มุมการ์ดโค้งมนกินเข้าไปในรูป
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        elevation: 0, 
        child: InkWell(
          onTap: () {
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizDetailScreen(quizData: quizData),
            ),
          );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🌟 ส่วนที่ 1: อัปเดตการดึงรูปภาพจาก Backend
              SizedBox(
                height: 152,
                width: double.infinity,
                child: quizData.image != null && quizData.image!.isNotEmpty
                    ? Image.network(
                        quizData.image!,
                        fit: BoxFit.cover, // ให้รูปขยายเต็มกรอบพอดี
                        errorBuilder: (context, error, stackTrace) {
                          // ถ้ารูปจาก URL โหลดไม่ขึ้น (ลิงก์ตาย) ให้กลับไปโชว์สีพื้นหลังแทน
                          return _buildFallbackImage();
                        },
                      )
                    : _buildFallbackImage(), // ถ้า Backend ไม่ส่งคีย์ image มา
              ),
              // ส่วนที่ 2: ข้อความด้านล่าง
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              quizData.title,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              quizData.description,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '+${quizData.points} Points',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // วิดเจ็ตตัวสำรอง (Fallback) ถ้ารูปโหลดไม่มา
  Widget _buildFallbackImage() {
    return Container(
      color: _getCategoryColor(quizData.category),
      child: const Center(
        child: Icon(Icons.image_not_supported, color: Colors.white, size: 40),
      ),
    );
  }

  // ฟังก์ชันเล็กๆ ช่วยสุ่มสีพื้นหลัง
  Color _getCategoryColor(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('vocab') || cat.contains('volcab')) return const Color(0xFFFBE07A); // สีเหลือง
    if (cat.contains('grammar')) return const Color(0xFFE28BB0); // สีชมพู
    if (cat.contains('reading')) return const Color(0xFFEE8A4B); // สีส้ม
    if (cat.contains('conversation')) return Colors.lightBlueAccent; // สีฟ้า
    if (cat.contains('sentence')) return Colors.greenAccent; // สีเขียว
    return Colors.blue;
  }
}