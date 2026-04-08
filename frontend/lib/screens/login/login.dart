import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // เพิ่มสำหรับ kIsWeb
import 'package:http/http.dart' as http; // เพิ่มสำหรับ API
import 'dart:convert'; // เพิ่มสำหรับ json
// คอมเมนต์ปิด google_sign_in ไว้ก่อนชั่วคราวเพื่อเทสต์ UI
// import 'package:google_sign_in/google_sign_in.dart'; 
import 'package:frontend/screens/signup/sign_up.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'dart:io';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // คอมเมนต์ตัวแปรนี้ไว้ก่อน
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isHoveringSignUp = false;
  
  // ----- ส่วนที่เพิ่มมาใหม่สำหรับ API -----
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loginAPI() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // เช็คแพลตฟอร์มว่ารันบน Web (localhost) หรือ Emulator (10.0.2.2)
    String baseUrl = 'https://petpoint.onrender.com'; // ค่าเริ่มต้นสำหรับ Web และ iOS Simulator
    

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Login สำเร็จ - ดึงข้อมูล user จาก response
        final userData = data['data'];
        final token = userData['token'];
        final userId = userData['user']?['uuid'] ?? userData['userId'] ?? userData['id'] ?? '';
        final username = userData['user']?['username'] ?? userData['username'] ?? 'User';
        final userEmail = userData['user']?['email'] ?? userData['email'] ?? email;
        final score = userData['user']?['currentScore'] ?? userData['currentScore'] ?? 0;
        final donatedScore = userData['user']?['donatedScore'] ?? userData['donatedScore'] ?? 0;
        final profileImage = userData['user']?['profileImage'] ?? userData['profileImage'];

        print("✅ Token: $token");
        print("✅ UserId: $userId");
        print("✅ Username: $username");

        // บันทึกข้อมูลลง AuthProvider เพื่อให้ทุกหน้าเข้าถึงได้
        if (mounted) {
          AuthProvider.of(context).login(
            userId: userId,
            token: token,
            username: username,
            email: userEmail,
            currentScore: score is int ? score : int.tryParse(score.toString()) ?? 0,
            donatedScore: donatedScore is int ? donatedScore : int.tryParse(donatedScore.toString()) ?? 0,
            profileImage: profileImage,
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!'), backgroundColor: Colors.green),
        );
        
        // ต้องสั่ง Navigator อีกครั้งเพื่อให้หน้า Login หายไปและไปที่หน้าหลักจริง
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        // Login ไม่สำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Login failed'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  // ------------------------------------

  Future<void> _handleGoogleSignIn() async {
    // จำลองการทำงานไปก่อน
    print("Google Sign-In Clicked! (Mock)");
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryYellow = Color(0xFFFDE170);
    const Color primaryGreen = Color(0xFF5AB073);

    return Scaffold(
      backgroundColor: primaryYellow,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // 1. ส่วนหัวข้อ "Login"
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: const Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // 2. รูปน้องแมว
            Positioned(
              bottom: 420,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/CatHello.png',
                height: 210,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.pets,
                    size: 100,
                    color: Colors.orange,
                  );
                },
              ),
            ),

            // 3. ส่วนฟอร์มสีขาว
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 500,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // ใส่ Controller ตรงนี้
                      _buildTextField(hint: 'Your Email', controller: _emailController),
                      const SizedBox(height: 20),

                      const Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // ใส่ Controller ตรงนี้
                      _buildTextField(hint: 'Your Password', isPassword: true, controller: _passwordController),
                      const SizedBox(height: 35),

                      // ปุ่ม Login (เพิ่ม Logic API)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _loginAPI,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading 
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // เส้นคั่น Or
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              'Or',
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // ปุ่ม Google
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _handleGoogleSignIn,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/Google_G_logo.svg.webp',
                                  height: 24,
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Sign up text
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              "If you don't have account, Please ",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onEnter: (_) => setState(() => _isHoveringSignUp = true),
                              onExit: (_) => setState(() => _isHoveringSignUp = false),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignUpScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'sign up',
                                  style: TextStyle(
                                    color: _isHoveringSignUp ? primaryGreen.withOpacity(0.7) : primaryGreen,
                                    fontWeight: FontWeight.bold,
                                    decoration: _isHoveringSignUp
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                    decorationThickness: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ปรับให้รับ controller
  Widget _buildTextField({required String hint, bool isPassword = false, required TextEditingController controller}) {
    return TextField(
      controller: controller, // เพิ่มบรรทัดนี้
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF5AB073), width: 1.5),
        ),
      ),
    );
  }
}