import 'package:flutter/material.dart';


import 'package:frontend/models/quiz.dart';
import 'package:frontend/screens/login/login.dart';
import 'package:frontend/screens/home/home.dart';
import 'package:frontend/screens/quiz/quiz_detail_screen.dart';
import 'package:frontend/screens/quiz/quiz_list_screen.dart';
import 'package:frontend/screens/shelter/shelter.dart';
import 'package:frontend/screens/myprofile/profile_screen.dart';
import 'package:frontend/screens/allscore/all_score.dart';
import 'package:frontend/screens/main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetPoint',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'GoogleSans',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B4226)),
        useMaterial3: true,
      ),
      
     
      initialRoute: '/login', 
      
      
      routes: {
        '/login': (context) => const LoginScreen(), 
        '/main': (context) => const MainNavigationScreen(), // หน้าหลักของแอปหลังจากล็อกอิน
        
        // หน้าอื่นๆ 
        '/foster': (context) => const PlaceholderScreen(title: 'Foster'),
        '/score': (context) => const PlaceholderScreen(title: 'Score'),
        '/quiz': (context) => const PlaceholderScreen(title: 'Quiz'),
        '/profile': (context) => const PlaceholderScreen(title: 'Profile'),
        '/news': (context) => const PlaceholderScreen(title: 'News'),
      },
    );
  }
}

// วิดเจ็ตหน้าว่างสำหรับรอการสร้างหน้าจริง
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Coming Soon: $title Page')),
    );
  }
}