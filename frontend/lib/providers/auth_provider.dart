import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  final _storage = const FlutterSecureStorage();

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

  /// โหลดข้อมูลจาก Secure Storage ตอนเปิดแอป
  Future<void> loadAuthData() async {
    final token = await _storage.read(key: 'token');
    final userId = await _storage.read(key: 'userId');
    
    if (token != null && userId != null) {
      _token = token;
      _userId = userId;
      _username = await _storage.read(key: 'username');
      _email = await _storage.read(key: 'email');
      _currentScore = int.tryParse(await _storage.read(key: 'currentScore') ?? '0') ?? 0;
      _donatedScore = int.tryParse(await _storage.read(key: 'donatedScore') ?? '0') ?? 0;
      _profileImage = await _storage.read(key: 'profileImage');
      notifyListeners();
    }
  }

  /// บันทึกข้อมูลลง Secure Storage
  Future<void> _saveToStorage() async {
    if (_userId != null) await _storage.write(key: 'userId', value: _userId);
    if (_token != null) await _storage.write(key: 'token', value: _token);
    if (_username != null) await _storage.write(key: 'username', value: _username);
    if (_email != null) await _storage.write(key: 'email', value: _email);
    await _storage.write(key: 'currentScore', value: _currentScore.toString());
    await _storage.write(key: 'donatedScore', value: _donatedScore.toString());
    if (_profileImage != null) {
      await _storage.write(key: 'profileImage', value: _profileImage);
    } else {
      await _storage.delete(key: 'profileImage');
    }
  }

  /// ล้างข้อมูลใน Secure Storage
  Future<void> _clearStorage() async {
    await _storage.deleteAll();
  }

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
    _saveToStorage();
  }

  /// อัปเดต score (เช่น หลัง quiz)
  void updateScore(int newScore, {int? donatedScore}) {
    _currentScore = newScore;
    if (donatedScore != null) _donatedScore = donatedScore;
    notifyListeners();
    _saveToStorage();
  }

  /// อัปเดตเฉพาะยอดบริจาค
  void updateDonatedScore(int newDonatedScore) {
    _donatedScore = newDonatedScore;
    notifyListeners();
    _saveToStorage();
  }

  /// อัปเดตโปรไฟล์ (ชื่อ + รูป)
  void updateProfile({String? username, String? profileImage}) {
    if (username != null) _username = username;
    if (profileImage != null) _profileImage = profileImage;
    notifyListeners();
    _saveToStorage();
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
    _clearStorage();
  }
}
