import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:frontend/screens/shelter/shelter.dart';
import 'package:frontend/screens/allscore/all_score.dart';
import 'package:frontend/screens/home/home.dart';
import 'package:frontend/screens/quiz/quiz_list_screen.dart';
import 'package:frontend/screens/myprofile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  
  const MainNavigationScreen({
    super.key, 
    this.initialIndex = 2, // Default to Home
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _selectedIndex;

  final List<Widget> _screens = [
    ShelterScreen(),
    AllScoreScreen(),
    HomeScreen(),
    QuizListScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF59AC77),
          unselectedItemColor: const Color(0xFFAAAAAA),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600, 
            fontFamily: 'GoogleSans', 
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500, 
            fontFamily: 'GoogleSans', 
            fontSize: 12,
          ),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 6.0),
                child: Icon(Icons.pets, size: 28),
              ),
              label: 'Foster',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 6.0),
                child: Icon(LucideIcons.trophy, size: 28),
              ),
              label: 'Score',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 6.0),
                child: Icon(LucideIcons.home, size: 28),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 6.0),
                child: Icon(LucideIcons.book, size: 28),
              ),
              label: 'Quiz',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 6.0),
                child: Icon(LucideIcons.user, size: 28),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
