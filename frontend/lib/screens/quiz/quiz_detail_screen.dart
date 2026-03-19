
import 'package:flutter/material.dart';
import '../../models/quiz.dart';
import '../../utils/app_colors.dart';

class QuizDetailScreen extends StatelessWidget {
  final Quiz quizData; // 👈 รับข้อมูลควิซที่ถูกกดส่งมาหน้านี้

  const QuizDetailScreen({super.key, required this.quizData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // พื้นหลังสีเทาอ่อน
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context), // 👈 กดแล้วย้อนกลับหน้าเดิม
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.8, // 👈 ปรับความสูงของกล่องตรงนี้ (ตอนนี้ตั้งไว้ที่ 80% ของหน้าจอ)
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24), // กล่องโค้งมนตามดีไซน์
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. รูปภาพหน้าปก
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _getCategoryColor(quizData.category), // สีปกจะเปลี่ยนตามหมวดหมู่เดียวกับที่แสดงในการ์ด
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text('ใส่รูปภาพตรงนี้', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),

              // 2. ชื่อและรายละเอียด
              Text(
                quizData.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                quizData.description,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 24),

              // 3. กล่องข้อมูล (ใช้ฟังก์ชัน _buildInfoRow ที่สร้างไว้ด้านล่าง)
              _buildInfoRow(Icons.book_outlined, '${quizData.questionCount} questions', AppColors.primaryGreen),
              _buildInfoRow(Icons.timer_outlined, '${quizData.duration} minutes', AppColors.primaryGreen),
              _buildInfoRow(Icons.star_border_rounded, '${quizData.points} points', AppColors.primaryGreen),
              _buildInfoRow(Icons.info_outline_rounded, quizData.category, AppColors.primaryGreen),

              const Spacer(), // 👈 ดันปุ่มให้ไปอยู่ล่างสุดของกล่อง

              // 4. ปุ่ม Start Quiz
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen, // สีเขียวตามตีมแอป
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // print('เริ่มทำควิซ: ${quizData.title}');
                    // นำทางไปหน้า QuizPlayScreen
                  },
                  child: const Text(
                    'Start Quiz',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🧩 เลโก้ชิ้นเล็กๆ สำหรับสร้างแถวข้อมูล (ช่วยให้โค้ดไม่รก)
  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 16),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // 🎨 ดึงสีปกให้ตรงกับในหน้า Card
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