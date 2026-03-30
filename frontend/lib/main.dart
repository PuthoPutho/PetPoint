import 'package:flutter/material.dart';
import 'package:frontend/screens/login/login.dart';
//import 'package:frontend/screens/signup/sign_up.dart';

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
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      // home: const LoginScreen(), // เปลี่ยนหน้าแรกเป็นหน้า Quiz
      // ตั้งค่าเริ่มต้นเปิดมาเป็นหน้าโฮม (Home Screen)
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        // ตัวอย่างการเพิ่มหน้าอื่นๆ (ตอนนี้ใส่ placeholder ไว้ก่อนเพื่อไม่ให้ App Crash เวลาคลิกเมนู)
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
