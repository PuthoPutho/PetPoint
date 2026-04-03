import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz.dart';

class QuizService {
  //  ข้อควรระวัง: ถ้าทดสอบด้วย Android Emulator ห้ามใช้ localhost นะครับ ให้ใช้ 10.0.2.2 แทน
  // ถ้าทดสอบบน iOS Simulator ใช้ localhost หรือ 127.0.0.1 ได้เลย
  // หรือถ้าเอา Backend ขึ้นเซิร์ฟเวอร์แล้ว (เช่น Render/Vercel) ให้ใส่ URL จริงตรงนี้
  static const String baseUrl = 'http://localhost:3000/api'; 

  // 1. ดึงควิซทั้งหมด (หน้า QuizList)
  static Future<List<Quiz>> getAllQuizzes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/quiz'));

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
      // 💡 ทริค: แนบ userId ไปกับ URL เพื่อให้ Backend รู้ว่าใครกำลังกดเข้ามาดู
      // (ถ้าโปรเจกต์คุณใช้ระบบ Token(JWT) ส่งผ่าน Header แทนได้เลยครับ)
      String url = '$baseUrl/quiz/$quizId/details';
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
}