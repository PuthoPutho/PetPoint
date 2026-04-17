import 'package:flutter/material.dart';

import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/login/login.dart';
import 'package:frontend/screens/main_navigation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  
  await Supabase.initialize(
    url: 'https://gthphqenkqgrbrezoeal.supabase.co',
    anonKey: 'sb_publishable_1ozRVgYoRL2aMmf4MDIlWQ__4uTFWty',
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // สร้าง AuthState ตัวเดียวที่จะแชร์ทั่วแอป
  final AuthState _authState = AuthState();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initAuth();
  }

  Future<void> _initAuth() async {
    
    await Future.wait([
      _authState.loadAuthData(),
      Future.delayed(const Duration(seconds: 4)), 
    ]);

    if (mounted) {
      setState(() {
        _isLoading = false; 
      });
    }
  }

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
        home: _isLoading
            ? const PetPointLoadingScreen()
            : ListenableBuilder(
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

// ==========================================
// Loading Screen
// ==========================================
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
            
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/logo.png', 
                width: 160,
                fit: BoxFit.contain,
              ),
            ),
            
            const SizedBox(height: 30),
            
           
            const Text(
              'PET POINT',
              style: TextStyle(
                color: Color(0xFF59AC77),
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