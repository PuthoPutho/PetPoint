import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/quiz.dart';
import '../../models/question.dart';
import '../../services/quiz_service.dart';
import 'quiz_result_screen.dart';

class QuizPlayScreen extends StatefulWidget {
  final Quiz quizData;

  const QuizPlayScreen({super.key, required this.quizData});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  List<QuizQuestion> _questions = [];
  bool isLoading = true; //  1. เพิ่มสถานะโหลด
  String? errorMessage;

  int _currentIndex = 0;
  int _score = 0;
  String? _selectedChoiceId; // 🌟 2. เปลี่ยนเป็น String ให้ตรงกับ Model
  final List<String?> _userAnswers = [];

  Timer? _timer;
  late int _timeLeft;

  int get _maxTime {
    if (widget.quizData.questionCount <= 0) return 10;
    return widget.quizData.duration ~/ widget.quizData.questionCount;
  }

  @override
  void initState() {
    super.initState();
    _loadQuestions(); // 🌟 3. เรียกโหลดข้อมูลแทนการเริ่มเวลาเลย
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await QuizService.getQuestionsForQuiz(widget.quizData.uuid);
      setState(() {
        _questions = questions;
        isLoading = false;
      });

      if (_questions.isNotEmpty) {
        _startTimer(); // โหลดเสร็จค่อยเริ่มจับเวลา
      } else {
        setState(() {
          errorMessage = 'ไม่พบคำถามในควิซนี้';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'โหลดข้อมูลล้มเหลว: $e';
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timeLeft = _maxTime;
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

//  
  Future<void> _nextQuestion() async {
    _timer?.cancel();
    _userAnswers.add(_selectedChoiceId);

    if (_selectedChoiceId != null) {
      final currentQ = _questions[_currentIndex];
      final selectedChoice = currentQ.choices.firstWhere(
          (c) => c.id == _selectedChoiceId,
          orElse: () => QuizChoice(id: '', text: '', isCorrect: false));

      if (selectedChoice.isCorrect) {
        _score++;
      }
    }

    // ถ้ายังไม่ถึงข้อสุดท้าย ก็ไปข้อต่อไปตามปกติ
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedChoiceId = null;
      });
      _startTimer();
    } else {
      // ==========================================
      //  สอบเสร็จแล้ว เตรียมข้อมูลเพื่อส่งให้ Backend
      // ==========================================
      setState(() {
        isLoading = true; // ขึ้นหน้า Loading หมุนๆ ระหว่างรอเซฟคะแนน
      });

      // แพ็คข้อมูลคำตอบให้ตรงกับที่ Backend (saveQuizHistory) ต้องการ
      List<Map<String, dynamic>> detailedAnswers = [];
      for (int i = 0; i < _questions.length; i++) {
        final q = _questions[i];
        final selectedId = _userAnswers[i];
        final choice = q.choices.firstWhere((c) => c.id == selectedId,
            orElse: () => QuizChoice(id: '', text: '', isCorrect: false));

        detailedAnswers.add({
          'questionId': q.id,
          'choiceId': selectedId,
          'isCorrect': choice.isCorrect,
        });
      }

      //  3. ยิง API บันทึกคะแนน!
      // ( ข้อควรระวัง: ลองเช็คในตาราง user ใน DB ว่ามี userId อะไรให้เทสต์บ้าง ผมขอสมมติเป็น 'user-1' ไปก่อนนะครับ)
      await QuizService.submitQuiz(
        userId: '85243aaf-423b-4da0-8bf6-6336ab35fbff', // <--- อนาคตถ้าเชื่อมระบบ Login สำเร็จ ค่อยดึง ID ของคนนั้นมาใส่ครับ
        quizId: widget.quizData.uuid, 
        answers: detailedAnswers,
      );

      setState(() {
        isLoading = false;
      });

      // ==========================================
      //  4. บันทึกเสร็จแล้ว ค่อยพาไปหน้า Result Screen
      // ==========================================
      if (!mounted) return; // กัน Error กรณีผู้ใช้ปิดแอปไปก่อน
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(
            quizData: widget.quizData,
            questions: _questions,
            userAnswers: _userAnswers,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorGreen = const Color(0xFF59AC77);

    // 🌟 ดักหน้าจอตอนโหลด และ ตอนพัง
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Color(0xFF59AC77))),
      );
    }

    if (errorMessage != null || _questions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(errorMessage ?? 'ไม่มีคำถามในระบบ', style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    final currentQuestion = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.quizData.title,
                    style: const TextStyle(fontFamily: 'GoogleSans', fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Part ${widget.quizData.tag}', // 🌟 เติมคำว่า Part ให้เนียนๆ
                    style: const TextStyle(fontFamily: 'GoogleSans', fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- 2. ข้อที่เท่าไหร่ ---
              Center(
                child: Text(
                  'Question ${_currentIndex + 1} / ${_questions.length}',
                  style: TextStyle(fontFamily: 'GoogleSans', fontSize: 18, fontWeight: FontWeight.bold, color: colorGreen),
                ),
              ),
              const SizedBox(height: 16),

              // --- 3. หลอดเวลา ---
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
                      widthFactor: _maxTime > 0 ? (_timeLeft / _maxTime).clamp(0.0, 1.0) : 0.0,
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

              // --- 4. คำถามและตัวเลือก ---
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4)),
                    ],
                    border: Border.all(color: Colors.grey.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // คำถาม
                      Expanded(
                        child: SingleChildScrollView(
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
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // ตัวเลือก
                      Column(
                        children: currentQuestion.choices.map((choice) {
                          final isSelected = _selectedChoiceId == choice.id;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedChoiceId = choice.id;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                                style: TextStyle(
                                  fontFamily: 'GoogleSans', 
                                  fontSize: 18,
                                  color: isSelected ? colorGreen : Colors.black,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // ปุ่ม Next
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorGreen,
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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