import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/quiz.dart';
import '../../utils/app_colors.dart';
import 'quiz_play_screen.dart';

class QuizDetailScreen extends StatelessWidget {
  final Quiz quizData; // 👈 รับข้อมูลควิซที่ถูกกดส่งมาหน้านี้

  const QuizDetailScreen({super.key, required this.quizData});

  @override
  Widget build(BuildContext context) {
    final int totalSeconds = quizData.duration;
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    
    String timeDisplay = '';
    if (minutes > 0 && seconds > 0) {
      timeDisplay = '$minutes min $seconds sec';
    } else if (minutes > 0) {
      timeDisplay = '$minutes min';
    } else {
      timeDisplay = '$seconds sec';
    }

    return Scaffold(
      backgroundColor: Colors.white, // พื้นหลังขาวตาม Figma
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.black),
          onPressed: () => Navigator.pop(context), 
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
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
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
                child: quizData.image != null && quizData.image!.isNotEmpty
    ? Image.network(quizData.image!, fit: BoxFit.cover)
    : Center(child: Icon(Icons.image_not_supported, color: Colors.white)),
              ),
              const SizedBox(height: 24),

              // 2. ชื่อและรายละเอียด
              Text(
                quizData.title,
                style: const TextStyle(fontFamily: 'GoogleSans', fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Part ${quizData.tag}',
                style: const TextStyle(fontFamily: 'GoogleSans', color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 24),

              // 3. กล่องข้อมูล (ใช้ฟังก์ชัน _buildInfoRow ที่สร้างไว้ด้านล่าง)
              _buildInfoRow(LucideIcons.bookOpen, '${quizData.questionCount} questions', AppColors.primaryGreen),
              _buildInfoRow(LucideIcons.timer, timeDisplay, AppColors.primaryGreen),
              _buildInfoRow(LucideIcons.star, '${quizData.points} points', AppColors.primaryGreen),
              _buildInfoRow(LucideIcons.info, '${quizData.description} ', AppColors.primaryGreen),

              const Spacer(),

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


                   

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPlayScreen(quizData: quizData),
                      ),
                    );

    },
                  child: Text(
                    quizData.isCompleted == true ? 're-attempt' : 'Start Quiz',
                    style: const TextStyle(fontFamily: 'GoogleSans', fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
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
          Expanded(
            child: Text(text, style: const TextStyle(fontFamily: 'GoogleSans', fontSize: 16)),
          ),
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