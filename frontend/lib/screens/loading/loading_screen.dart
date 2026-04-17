// lib/loading_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:frontend/screens/home/home.dart'; 

class PetPointLoadingScreen extends StatefulWidget {
  const PetPointLoadingScreen({super.key});

  @override
  State<PetPointLoadingScreen> createState() => _PetPointLoadingScreenState();
}

class _PetPointLoadingScreenState extends State<PetPointLoadingScreen> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
  
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

   
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // โลโก้
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/logo.png', 
                width: 160,
                fit: BoxFit.contain,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // ข้อความ
            const Text(
              'PET POINT',
              style: TextStyle(
                color: Color(0xFF63B47B),
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

