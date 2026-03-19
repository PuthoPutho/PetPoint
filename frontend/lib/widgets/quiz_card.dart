import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../screens/quiz/quiz_detail_screen.dart';

class QuizCard extends StatelessWidget {
  final Quiz quizData;

  const QuizCard({super.key, required this.quizData});

  @override
  Widget build(BuildContext context) {
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
        elevation: 0, // ลดเงาให้ดูแบนๆ คล้ายดีไซน์
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
              // ส่วนที่ 1: รูปภาพหน้าปก (ใช้กรอบสีแทนชั่วคราว)
              Container(
                height: 152,
                width: double.infinity,
                color: _getCategoryColor(quizData.category),
                child: const Center(
                  child: Text('ใส่รูปภาพตรงนี้', style: TextStyle(color: Colors.white)),
                ),
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

  // ฟังก์ชันเล็กๆ ช่วยสุ่มสีพื้นหลังให้ตรงส่วนหมวดหมู่
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