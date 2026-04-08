import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class UserService {
  //  1. ประกาศ baseUrl ไว้ที่นี่เลย (ถ้าตอนเทสต์ใช้ IP อื่น อย่าลืมเปลี่ยนให้ตรงกับของ quiz_service นะครับ)
  static const String serverUrl = 'https://petpoint.onrender.com'; // เอาไว้ดึงรูป
  static const String baseUrl = '$serverUrl/api'; // เอาไว้ยิง API

  static String getImageUrl(String? path) {
  if (path == null || path.isEmpty || path == "null") return "";

  //  ถ้าเป็นลิงก์เต็มจาก Supabase (https://...) ให้ส่งคืนไปเลย
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return path;
  }

  //  สำหรับรูปเก่าในเครื่อง (/uploads/...) 
  // ตรวจสอบว่า serverUrl ลงท้ายด้วย / หรือไม่ เพื่อป้องกันเครื่องหมาย // ซ้อนกัน
  final cleanServerUrl = serverUrl.endsWith('/') 
      ? serverUrl.substring(0, serverUrl.length - 1) 
      : serverUrl;
      
  final cleanPath = path.startsWith('/') ? path : '/$path';

  return '$cleanServerUrl$cleanPath';
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

  // ดึงข้อมูล Shelter ทั้งหมดจาก Database
  static Future<List<dynamic>> getAllShelters() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/shelter'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'] ?? [];
      }
    } catch (e) {
      print('Error fetching shelters: $e');
    }
    return [];
  }

  //  ฟังก์ชันอัปเดตโปรไฟล์ (ส่งได้ทั้งชื่อ และ ไฟล์รูปภาพ)
  static Future<bool> updateProfile(
    String userId,
    String username,
    Uint8List? imageBytes,
  ) async {
    try {
      // ใช้ MultipartRequest สำหรับการแนบไฟล์
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/profile/$userId'),
      );

      // 1. แนบชื่อไป
      request.fields['username'] = username;

      // 2. ถ้ามีการเลือกรูปใหม่ ให้แนบไฟล์รูปไปด้วย (ใช้ bytes แทน path เพื่อให้รันได้ทุก platform)
      if (imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'profileImage', // ชื่อฟิลด์ที่ Backend รอรับ
            imageBytes,
            filename: 'profile_image.jpg', // ต้องใส่ชื่อไฟล์ด้วย
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
      final response = await http.get(
        Uri.parse('$baseUrl/quiz/spider-chart/$userId'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'] ?? [];
      }
    } catch (e) {
      print('Error fetching spider chart: $e');
    }
    return [];
  }

  // บริจาคคะแนน
  static Future<Map<String, dynamic>?> donateToShelter(
    String userId,
    String shelterId,
    int amount,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/donation'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'shelterId': shelterId,
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['data'];
      }
    } catch (e) {
      print('Error donating: $e');
    }
    return null;
  }
}
