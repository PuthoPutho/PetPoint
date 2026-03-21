import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/quiz.dart';
import '../../models/question.dart';
import '../../services/mock_quiz_service.dart';

class QuizPlayScreen extends StatefulWidget {
  final Quiz quizData;

  const QuizPlayScreen({super.key, required this.quizData});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  late List<QuizQuestion> _questions;
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedChoiceId;

  Timer? _timer;
  int _timeLeft = 10; // 60 วินาทีต่อข้อ

  @override
  void initState() {
    super.initState();
    _questions = MockQuizService.getMockQuestionsForQuiz(widget.quizData.uuid);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timeLeft = 10;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    _timer?.cancel();

    if (_selectedChoiceId != null) {
      final currentQ = _questions[_currentIndex];
      final selectedChoice = currentQ.choices.firstWhere((c) => c.id == _selectedChoiceId);
      if (selectedChoice.isCorrect) {
        _score++;
      }
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedChoiceId = null;
      });
      _startTimer();
    } else {
      print('สอบเสร็จแล้ว! ได้คะแนน $_score / ${_questions.length}');
      // TODO: ใส่คำสั่งเด้งไปหน้า Result ตรงนี้
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentIndex];
    final colorGreen = const Color(0xFF59AC77);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (ชื่อควิซ และ Part)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.quizData.title,
                    style: const TextStyle(fontFamily: 'GoogleSans', fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.quizData.tag,
                    style: const TextStyle(fontFamily: 'GoogleSans', fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 2. บอกว่าอยู่ข้อที่เท่าไหร่
              Center(
                child: Text(
                  'Question ${_currentIndex + 1} / ${_questions.length}',
                  style: TextStyle(fontFamily: 'GoogleSans', fontSize: 18, fontWeight: FontWeight.bold, color: colorGreen),
                ),
              ),
              const SizedBox(height: 16),

              // 3. หลอดจับเวลา
              Container(
                height: 30,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorGreen.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: _timeLeft / 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorGreen,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 12),
                          const Icon(LucideIcons.timer, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text('$_timeLeft Secs', style: const TextStyle(fontFamily: 'GoogleSans', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 4. กรอบคำถามและตัวเลือก
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${_currentIndex + 1}',
                        style: const TextStyle(fontFamily: 'GoogleSans', fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        currentQuestion.question,
                        style: const TextStyle(fontFamily: 'GoogleSans', fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 32),

                      // ==========================================
                      // 🔥 ส่วนของกรอบคำตอบยาวเต็มกรอบ มีช่องไฟ 🔥
                      // ==========================================
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: currentQuestion.choices.map((choice) {
                              final isSelected = _selectedChoiceId == choice.id;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedChoiceId = choice.id;
                                  });
                                },
                                child: Container(
                                  width: double.infinity, // ยาวเต็มกรอบ
                                  margin: const EdgeInsets.only(bottom: 12), // ช่องไฟระหว่างข้อ
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // ความหนาของกรอบ
                                  decoration: BoxDecoration(
                                    color: isSelected ? colorGreen.withOpacity(0.1) : Colors.white,
                                    border: Border.all(
                                      color: isSelected ? colorGreen : Colors.grey.shade300,
                                      width: isSelected ? 2 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    choice.text,
                                    style: TextStyle(fontFamily: 'GoogleSans', 
                                      fontSize: 18,
                                      color: isSelected ? colorGreen : Colors.black,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      // ==========================================

                      // 5. ปุ่ม Next
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorGreen,
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: _selectedChoiceId != null ? _nextQuestion : null,
                          child: const Text(
                            'Next',
                            style: TextStyle(fontFamily: 'GoogleSans', fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
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
}