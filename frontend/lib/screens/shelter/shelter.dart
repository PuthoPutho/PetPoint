import 'package:flutter/material.dart';
import 'package:frontend/widgets/shelter_card.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  runApp(
    const MaterialApp(home: ShelterScreen(), debugShowCheckedModeBanner: false),
  );
}

class ShelterScreen extends StatelessWidget {
  const ShelterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Pet Shelters',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // ใช้ ListView เพื่อให้หน้าจอ scroll ได้เมื่อมีการ์ดหลายใบ
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- ส่วนที่ 1: บัตร How to Donate ---
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF67AC7D),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'How to Donate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStepCard('สะสมให้ครบ\n100 Point', Icons.pets),
                    _buildStepCard(
                      'กดเลือกสถานที่\nที่ต้องการบริจาค',
                      LucideIcons.mousePointer2,
                    ),
                    _buildStepCard(
                      'กดคลิกที่ปุ่ม\nConfirm',
                      LucideIcons.checkSquare,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24), // ระยะห่างระหว่างหัวกับรายการการ์ด
          // --- ส่วนที่ 2: รายการ Shelter Card ---
          ShelterCard(
            imageWidget: Image.asset(
              'assets/shelter1.png', // ใส่ URL รูปภาพของคุณที่นี่
              fit: BoxFit.cover,
            ),
            title: 'บ้านนางฟ้าของสัตว์จร',
            subtitle: 'จังหวัดสระบุรี',
          ),
          ShelterCard(
            imageWidget: Image.asset(
              'assets/shelter1.png', // ใส่ URL รูปภาพของคุณที่นี่
              fit: BoxFit.cover,
            ),
            title: 'บ้านนางฟ้าของสัตว์จร',
            subtitle: 'จังหวัดสระบุรี',
          ),

          const SizedBox(height: 80), // เผื่อระยะด้านล่าง
        ],
      ),

      // // Bottom Navigation Bar (เปิดคอมเมนต์เพื่อให้เหมือนรูปต้นฉบับ)
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   selectedItemColor: const Color(0xFF67AC7D),
      //   unselectedItemColor: Colors.grey,
      //   showSelectedLabels: true,
      //   showUnselectedLabels: true,
      //   currentIndex: 0,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Foster'),
      //     BottomNavigationBarItem(
      //       icon: Icon(LucideIcons.trophy),
      //       label: 'Score',
      //     ),
      //     BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
      //     BottomNavigationBarItem(
      //       icon: Icon(LucideIcons.bookOpen),
      //       label: 'Quiz',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(LucideIcons.user),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildStepCard(String title, IconData icon) {
    return Container(
      width: 100,
      height: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF8B5E3C),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Icon(icon, color: const Color(0xFF8B5E3C), size: 32),
        ],
      ),
    );
  }
}
