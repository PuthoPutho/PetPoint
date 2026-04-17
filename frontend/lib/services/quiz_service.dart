import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz.dart';
import '../models/question.dart'; //  

class QuizService {
 
  static const String baseUrl = 'https://petpoint.onrender.com/api'; 

  static Future<List<Quiz>> getAllQuizzes({String? userId}) async {
    try {
     
      String url = '$baseUrl/quiz';
      if (userId != null) {
        url += '?userId=$userId';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        
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

 
  static Future<Quiz> getQuizDetails(String quizId, {String? userId}) async {
    try {
      
      String url = '$baseUrl/quiz/$quizId'; 
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


    
  static Future<bool> submitQuiz({
    required String userId,
    required String quizId,
    required List<Map<String, dynamic>> answers,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/quiz/submit'),
        headers: {'Content-Type': 'application/json'},
     
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



  
  static Future<List<dynamic>> getUserQuizHistory(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/quiz/history/$userId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? []; 
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