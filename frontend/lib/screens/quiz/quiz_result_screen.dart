import 'package:flutter/material.dart';
import '../../models/quiz.dart';
import '../../models/question.dart';
import '../main_navigation.dart'; 

class QuizResultScreen extends StatelessWidget {
  final Quiz quizData;
  final List<QuizQuestion> questions;
  final List<String?> userAnswers; 

  const QuizResultScreen({
    super.key,
    required this.quizData,
    required this.questions,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    // 1. คำนวณคะแนน
    int correctCount = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] != null) {
      
        final selectedChoice = questions[i].choices.firstWhere((c) => c.id == userAnswers[i],
            orElse: () => QuizChoice(id: '', text: '', isCorrect: false));
        if (selectedChoice.isCorrect) correctCount++;
      }
    }
    int wrongCount = questions.length - correctCount;
    final colorGreen = const Color(0xFF59AC77);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // ==========================================
              //  Total Score
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
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
                  children: [
                    const Text('Total Score', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('$correctCount', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: colorGreen)),
                        const Text(' / 10', style: TextStyle(fontSize: 24, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    
                    Transform.translate(
                      offset: const Offset(0, 48), 
                      child: Image.asset(
                        'assets/catresult.png', 
                        height: 150,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                    

                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorGreen,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          _buildStatBox('10', 'Total Question'),
                          const SizedBox(width: 8),
                          _buildStatBox('$correctCount', 'Correct'),
                          const SizedBox(width: 8),
                          _buildStatBox('$wrongCount', 'Wrong'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ==========================================
              //  ปุ่ม Next
              // ==========================================
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                   
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainNavigationScreen(initialIndex: 3)),
                      (route) => false,
                    );
                  },
                  child: const Text('Next', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),

              // ==========================================
              //Answer Key
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
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
                  children: [
                    const Text('Answer Key', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(quizData.title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                    Text("Part ${quizData.tag}", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 24),

                    
                    ...List.generate(questions.length, (index) {
                      final question = questions[index];
                      final userAnswerId = userAnswers[index];
                      
                     
                      final correctChoice = question.choices.firstWhere((c) => c.isCorrect);
                      
                    
                      QuizChoice? userChoice;
                      if (userAnswerId != null) {
                        userChoice = question.choices.firstWhere((c) => c.id == userAnswerId);
                      }
                      
                   
                      final isCorrect = userChoice != null && userChoice.isCorrect;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Question ${index + 1}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorGreen)),
                                Text(
                                  isCorrect ? 'Correct' : 'Wrong', 
                                  style: TextStyle(
                                    fontSize: 16, 
                                    fontWeight: FontWeight.bold, 
                                    color: isCorrect ? colorGreen : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            
                         
                            Text(question.question, style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 12),

                            
                            if (!isCorrect)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.05),
                                  border: Border.all(color: Colors.red.shade200),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  userChoice == null ? 'Your Answer: (หมดเวลา)' : 'Your Answer: ${userChoice.text}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),

                            
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: colorGreen.withOpacity(0.05),
                                border: Border.all(color: colorGreen.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('Correct Answer: ${correctChoice.text}', style: TextStyle(color: colorGreen)),
                            ),

                            
                            Text('Explanation: ${question.explanation}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🧩 เลโก้สร้างกล่องสีเหลือง 3 ช่อง
  Widget _buildStatBox(String number, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFBE07A), // สีเหลือง
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(number, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
