import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; 
import 'package:http/http.dart' as http; 
import 'dart:convert'; 
// import 'package:google_sign_in/google_sign_in.dart'; 

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  
  bool _isHoveringLogin = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUpAPI() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final String baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/signup'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully! Please login.'), backgroundColor: Colors.green),
        );
        Navigator.pop(context); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Sign up failed'), backgroundColor: Colors.red),
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
            const Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            
            Positioned(
              bottom: 470, 
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
                height: 550,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Username', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      _buildTextField(hint: 'Your username', controller: _usernameController),
                      const SizedBox(height: 15),

                      const Text('Email', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      _buildTextField(hint: 'Your Email', controller: _emailController),
                      const SizedBox(height: 15),

                      const Text('Password', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      _buildTextField(hint: 'Your Password', isPassword: true, controller: _passwordController),
                      const SizedBox(height: 35),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signUpAPI,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 0,
                          ),
                          child: _isLoading 
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Sign-up', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 25),

                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text('Or', style: TextStyle(color: Colors.grey.shade400)),
                          ),
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                        ],
                      ),
                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _handleGoogleSignIn,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/Google_G_logo.svg.webp',
                                  height: 24,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  'Continue with Google',
                                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text("Already have an account? ", style: TextStyle(color: Colors.grey.shade600)),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onEnter: (_) => setState(() => _isHoveringLogin = true),
                              onExit: (_) => setState(() => _isHoveringLogin = false),
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Text(
                                  'Log in',
                                  style: TextStyle(
                                    color: _isHoveringLogin ? primaryGreen.withOpacity(0.7) : primaryGreen,
                                    fontWeight: FontWeight.bold,
                                    decoration: _isHoveringLogin ? TextDecoration.underline : TextDecoration.none,
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

 
  Widget _buildTextField({required String hint, bool isPassword = false, required TextEditingController controller}) {
    return TextField(
      controller: controller, 
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