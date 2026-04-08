import 'package:flutter/material.dart';
import '../../widgets/news_card.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'News & Announcements',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: const [
          NewsCard(
            title: "New Character!!!!",
            description: "Cute yellow cat is now available in the draw!",
            imagePath: 'assets/OrangeCat.png',
            content: "Golden Whisker: The Bringer of Sunshine\n\n\"Amidst the quiet loneliness, a soft golden glow arrives to comfort your heart.\"\n\nJust like a beam of sunlight piercing through the clouds on a gloomy day, Golden Whisker is more than just an ordinary cat. It is the embodiment of brightness and hope, standing ready to accompany you through every step of your journey.",
          ),
          NewsCard(
            title: "Limited Edition!",
            description: "Get the baby cat before time runs out.",
            imagePath: 'assets/OrangeCatBaby.png',
            content: "The Baby Orange Cat has arrived! This limited-time character requires extra love and care. Feed them with milk to watch them grow!",
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   currentIndex: 2,
      //   selectedItemColor: const Color(0xFF62B179),
      //   unselectedItemColor: Colors.grey,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Foster'),
      //     BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), label: 'Score'),
      //     BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: 'Quiz'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      //   ],
      // ),
    );
  }
}