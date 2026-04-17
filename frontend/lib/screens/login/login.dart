import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; 
import 'package:http/http.dart' as http; 
import 'dart:convert'; 
import 'package:google_sign_in/google_sign_in.dart';
import 'package:frontend/screens/signup/sign_up.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  bool _isHoveringSignUp = false;

  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isNavigating = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _syncGoogleLoginWithBackend(supabase.User user) async {
    if (_isNavigating) return;
    _isNavigating = true; 

    if (mounted) setState(() => _isLoading = true);
    String baseUrl = dotenv.env['BASE_URL'] ?? 'https://petpoint.onrender.com';

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/google'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": user.email,
          "username":
              user.userMetadata?['full_name'] ?? user.email?.split('@')[0],
          "profileImage": user.userMetadata?['avatar_url'],
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final userData = data['data'];
        final token = userData['token'];
        final userId =
            userData['user']?['uuid'] ??
            userData['userId'] ??
            userData['id'] ??
            '';
        final username = userData['user']?['username'] ?? 'User';
        final userEmail = userData['user']?['email'] ?? user.email;
        final score = userData['user']?['currentScore'] ?? 0;
        final donatedScore = userData['user']?['donatedScore'] ?? 0;
        final profileImage = userData['user']?['profileImage'];

        if (mounted) {
          AuthProvider.of(context).login(
            userId: userId,
            token: token,
            username: username,
            email: userEmail,
            currentScore: score is int
                ? score
                : int.tryParse(score.toString()) ?? 0,
            donatedScore: donatedScore is int
                ? donatedScore
                : int.tryParse(donatedScore.toString()) ?? 0,
            profileImage: profileImage,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome, $username!'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacementNamed(context, '/main');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Login failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
        _isNavigating = false;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
      _isNavigating = false;
    } finally {
      if (mounted && !_isNavigating) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginAPI() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email containing "@"')),
      );
      return;
    }

    setState(() => _isLoading = true);

   
    String baseUrl = dotenv.env['BASE_URL'] ?? 'https://petpoint.onrender.com';

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
      
        final userData = data['data'];
        final token = userData['token'];
        final userId =
            userData['user']?['uuid'] ??
            userData['userId'] ??
            userData['id'] ??
            '';
        final username =
            userData['user']?['username'] ?? userData['username'] ?? 'User';
        final userEmail =
            userData['user']?['email'] ?? userData['email'] ?? email;
        final score =
            userData['user']?['currentScore'] ?? userData['currentScore'] ?? 0;
        final donatedScore =
            userData['user']?['donatedScore'] ?? userData['donatedScore'] ?? 0;
        final profileImage =
            userData['user']?['profileImage'] ?? userData['profileImage'];

        print("✅ Token: $token");
        print("✅ UserId: $userId");
        print("✅ Username: $username");

        if (mounted) {
          AuthProvider.of(context).login(
            userId: userId,
            token: token,
            username: username,
            email: userEmail,
            currentScore: score is int
                ? score
                : int.tryParse(score.toString()) ?? 0,
            donatedScore: donatedScore is int
                ? donatedScore
                : int.tryParse(donatedScore.toString()) ?? 0,
            profileImage: profileImage,
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome, $username!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacementNamed(context, '/main');
      } else {
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Login failed'),
            backgroundColor: Colors.red,
          ),
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
    if (mounted) setState(() => _isLoading = true);

    try {
   
      final webClientId = dotenv.env['WEB_CLIENT_ID'] ?? '';
      final iosClientId = dotenv.env['IOS_CLIENT_ID'] ?? '';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        if (mounted) setState(() => _isLoading = false);
        return; 
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) throw 'No Access Token found.';
      if (idToken == null) throw 'No ID Token found.';

      final supabase.AuthResponse response = await supabase
          .Supabase
          .instance
          .client
          .auth
          .signInWithIdToken(
            provider: supabase.OAuthProvider.google,
            idToken: idToken,
            accessToken: accessToken,
          );

      if (response.user != null) {
       
        await _syncGoogleLoginWithBackend(response.user!);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
                      
                      _buildTextField(
                        hint: 'Your Email',
                        controller: _emailController,
                      ),
                      const SizedBox(height: 18),

                      const Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      _buildTextField(
                        hint: 'Your Password',
                        isPassword: true,
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 35),

                      // ปุ่ม Login 
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _loginAPI,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),

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
                      const SizedBox(height: 20),

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
                              onEnter: (_) =>
                                  setState(() => _isHoveringSignUp = true),
                              onExit: (_) =>
                                  setState(() => _isHoveringSignUp = false),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'sign up',
                                  style: TextStyle(
                                    color: _isHoveringSignUp
                                        ? primaryGreen.withOpacity(0.7)
                                        : primaryGreen,
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
  Widget _buildTextField({
    required String hint,
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller, 
      obscureText: isPassword,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400 ,fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
