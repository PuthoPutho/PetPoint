import 'package:flutter/material.dart';

import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/login/login.dart';
import 'package:frontend/screens/main_navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // สร้าง AuthState ตัวเดียวที่จะแชร์ทั่วแอป
  final AuthState _authState = AuthState();

  @override
  void dispose() {
    _authState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      notifier: _authState,
      child: MaterialApp(
        title: 'PetPoint',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'GoogleSans',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6B4226),
          ),
          useMaterial3: true,
        ),
        // ใช้ ListenableBuilder เฉพาะในส่วน home เท่านั้น
        // เพื่อไม่ให้ต้อง rebuild MaterialApp ทั้งหมดเมื่อคะแนนหรือโปรไฟล์เปลี่ยน
        home: ListenableBuilder(
          listenable: _authState,
          builder: (context, _) {
            return _authState.isLoggedIn
                ? const MainNavigationScreen()
                : const LoginScreen();
          },
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/main': (context) => const MainNavigationScreen(),
          '/foster': (context) => const PlaceholderScreen(title: 'Foster'),
          '/score': (context) => const PlaceholderScreen(title: 'Score'),
          '/quiz': (context) => const PlaceholderScreen(title: 'Quiz'),
          '/profile': (context) => const PlaceholderScreen(title: 'Profile'),
          '/news': (context) => const PlaceholderScreen(title: 'News'),
        },
      ),
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