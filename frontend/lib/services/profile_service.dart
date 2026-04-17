import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class UserService {
 
  static const String serverUrl = 'https://petpoint.onrender.com'; 
  static const String baseUrl = '$serverUrl/api'; 

  static String getImageUrl(String? path) {
  if (path == null || path.isEmpty || path == "null") return "";

  
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return path;
  }

  
  final cleanServerUrl = serverUrl.endsWith('/') 
      ? serverUrl.substring(0, serverUrl.length - 1) 
      : serverUrl;
      
  final cleanPath = path.startsWith('/') ? path : '/$path';

  return '$cleanServerUrl$cleanPath';
}

  
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

  
  static Future<bool> updateProfile(
    String userId,
    String username,
    Uint8List? imageBytes,
  ) async {
    try {
      
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/profile/$userId'),
      );

    
      request.fields['username'] = username;

      
      if (imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'profileImage', 
            imageBytes,
            filename: 'profile_image.jpg', 
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
