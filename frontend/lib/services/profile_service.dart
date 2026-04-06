import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class UserService {
  //  1. ประกาศ baseUrl ไว้ที่นี่เลย (ถ้าตอนเทสต์ใช้ IP อื่น อย่าลืมเปลี่ยนให้ตรงกับของ quiz_service นะครับ)
  static const String serverUrl = 'http://localhost:3000'; // เอาไว้ดึงรูป
  static const String baseUrl = '$serverUrl/api';             // เอาไว้ยิง API 

  static String getImageUrl(String? path) {
    if (path == null || path.isEmpty || path == "null") return "";
    if (path.startsWith('http')) return path;
    
    // เอา serverUrl มาต่อ จะได้ http://localhost:3000/uploads/xxx.jpg พอดี!
    return '$serverUrl$path'; 
  }

  // ดึงโปรไฟล์
  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/profile/$userId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
    return null;
  }

 //  ฟังก์ชันอัปเดตโปรไฟล์ (ส่งได้ทั้งชื่อ และ ไฟล์รูปภาพ)
  static Future<bool> updateProfile(String userId, String username, File? imageFile) async {
    try {
      // ใช้ MultipartRequest สำหรับการแนบไฟล์
      var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/profile/$userId'));
      
      // 1. แนบชื่อไป
      request.fields['username'] = username;

      // 2. ถ้ามีการเลือกรูปใหม่ ให้แนบไฟล์รูปไปด้วย
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profileImage', // ชื่อฟิลด์ที่ Backend รอรับ
            imageFile.path,
          ),
        );
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        print('✅ อัปเดตโปรไฟล์สำเร็จ!');
        return true;
      } else {
        print('❌ อัปเดตโปรไฟล์ไม่สำเร็จ: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error updating profile: $e');
      return false;
    }
  }

  // ดึงข้อมูลใยแมงมุม 
  static Future<List<dynamic>> getSpiderChartData(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/quiz/spider-chart/$userId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'] ?? [];
      }
    } catch (e) {
      print('Error fetching spider chart: $e');
    }
    return [];
  }
}