import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz.dart';
import '../models/question.dart'; //  

class QuizService {
  //  ข้อควรระวัง: ถ้าทดสอบด้วย Android Emulator ห้ามใช้ localhost นะครับ ให้ใช้ 10.0.2.2 แทน
  // ถ้าทดสอบบน iOS Simulator ใช้ localhost หรือ 127.0.0.1 ได้เลย
  // หรือถ้าเอา Backend ขึ้นเซิร์ฟเวอร์แล้ว (เช่น Render/Vercel) ให้ใส่ URL จริงตรงนี้
  static const String baseUrl = 'https://petpoint.onrender.com/api'; 

  // 1. ดึงควิซทั้งหมด (หน้า QuizList)
  static Future<List<Quiz>> getAllQuizzes({String? userId}) async {
    try {
      // 🌟 ปรับปรุง: รองรับการส่ง userId เพื่อเช็คสถานะ isCompleted รายบุคคล
      String url = '$baseUrl/quiz';
      if (userId != null) {
        url += '?userId=$userId';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // สมมติว่า Backend ส่ง JSON หน้าตา { "success": true, "data": [ ... ] }
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> quizList = body['data'];
        
        return quizList.map((json) => Quiz.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load quizzes');
      }
    } catch (e) {
      throw Exception('Error fetching quizzes: $e');
    }
  }

  // 2. ดึงรายละเอียดควิซ (หน้า QuizDetail)
  static Future<Quiz> getQuizDetails(String quizId, {String? userId}) async {
    try {
      //ทริค: แนบ userId ไปกับ URL เพื่อให้ Backend รู้ว่าใครกำลังกดเข้ามาดู
      // (ถ้าโปรเจกต์คุณใช้ระบบ Token(JWT) ส่งผ่าน Header แทนได้เลยครับ)
      String url = '$baseUrl/quiz/$quizId'; // 👈 แก้จาก /details เป็นแบบปกติให้ตรงกับ Backend
      if (userId != null) {
        url += '?userId=$userId';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return Quiz.fromJson(body['data']);
      } else {
        throw Exception('Failed to load quiz details');
      }
    } catch (e) {
      throw Exception('Error fetching quiz details: $e');
    }
  }


  static Future<List<QuizQuestion>> getQuestionsForQuiz(String quizId) async {
    try {
      //  อย่าลืมเช็ค Endpoint ของ Backend ด้วยนะครับว่าใช้เส้นทางนี้ไหม
      final response = await http.get(Uri.parse('$baseUrl/quiz/$quizId/questions'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> questionsList = body['data'];
        
        return questionsList.map((json) => QuizQuestion.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }


  // ฟังก์ชันสำหรับส่งคะแนนและคำตอบไป Backend
  static Future<bool> submitQuiz({
    required String userId,
    required String quizId,
    required List<Map<String, dynamic>> answers,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/quiz/submit'),
        headers: {'Content-Type': 'application/json'},
        // แปลงข้อมูลเป็น JSON ให้ตรงกับที่ Backend รอรับ
        body: jsonEncode({
          'userId': userId,
          'quizId': quizId,
          'answers': answers,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ บันทึกคะแนนเข้า Database สำเร็จ!');
        return true;
      } else {
        print('❌ บันทึกไม่สำเร็จ: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ เกิดข้อผิดพลาดในการส่งคะแนน: $e');
      return false;
    }
  }



  //  ฟังก์ชันดึงประวัติการสอบ (Quiz History)
  static Future<List<dynamic>> getUserQuizHistory(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/quiz/history/$userId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? []; // ส่งเฉพาะ Array ประวัติการสอบกลับไปให้ UI
      } else {
        print('❌ ดึงประวัติไม่สำเร็จ: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ เกิดข้อผิดพลาดในการดึงประวัติ: $e');
      return [];
    }
  }

}