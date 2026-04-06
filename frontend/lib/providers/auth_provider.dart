import 'package:flutter/material.dart';

/// เก็บข้อมูล user ที่ login แล้วทั่วทั้งแอป
class AuthProvider extends InheritedNotifier<AuthState> {
  const AuthProvider({
    super.key,
    required AuthState super.notifier,
    required super.child,
  });

  /// ดึง AuthState จาก context ในหน้าไหนก็ได้
  static AuthState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    assert(provider != null, 'No AuthProvider found in context');
    return provider!.notifier!;
  }
}

/// State ที่เก็บข้อมูล user session
class AuthState extends ChangeNotifier {
  String? _userId;
  String? _token;
  String? _username;
  String? _email;
  int _currentScore = 0;
  int _donatedScore = 0; // 🎁 ยอดบริจาครวม
  String? _profileImage;
  int _refreshTrigger = 0; // 🌟 ตัวจุดระเบิด (Signal) สำหรับบอกให้หน้าอื่นๆ รีโหลดข้อมูล

  // Getters
  String? get userId => _userId;
  String? get token => _token;
  String? get username => _username;
  String? get email => _email;
  int get currentScore => _currentScore;
  int get donatedScore => _donatedScore;
  String? get profileImage => _profileImage;
  int get refreshTrigger => _refreshTrigger; // Getter สำหรับให้หน้าอื่นๆ คอยฟัง (Watch)
  bool get isLoggedIn => _userId != null && _token != null;

  /// เรียกหลัง login สำเร็จ เพื่อบันทึกข้อมูล user
  void login({
    required String userId,
    required String token,
    required String username,
    required String email,
    int currentScore = 0,
    int donatedScore = 0,
    String? profileImage,
  }) {
    _userId = userId;
    _token = token;
    _username = username;
    _email = email;
    _currentScore = currentScore;
    _donatedScore = donatedScore;
    _profileImage = profileImage;
    notifyListeners();
  }

  /// อัปเดต score (เช่น หลัง quiz)
  void updateScore(int newScore, {int? donatedScore}) {
    _currentScore = newScore;
    if (donatedScore != null) _donatedScore = donatedScore;
    notifyListeners();
  }

  /// อัปเดตเฉพาะยอดบริจาค
  void updateDonatedScore(int newDonatedScore) {
    _donatedScore = newDonatedScore;
    notifyListeners();
  }

  /// อัปเดตโปรไฟล์ (ชื่อ + รูป)
  void updateProfile({String? username, String? profileImage}) {
    if (username != null) _username = username;
    if (profileImage != null) _profileImage = profileImage;
    notifyListeners();
  }

  /// เรียกเมื่อต้องการให้หน้าอื่นๆ (เช่น Profile) ทำการโหลดข้อมูลใหม่จาก API
  void triggerRefresh() {
    _refreshTrigger++;
    notifyListeners();
  }

  /// ล้างข้อมูลเมื่อ logout
  void logout() {
    _userId = null;
    _token = null;
    _username = null;
    _email = null;
    _currentScore = 0;
    _donatedScore = 0;
    _profileImage = null;
    notifyListeners();
  }
}
