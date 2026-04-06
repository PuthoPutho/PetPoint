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

          const SizedBox(height: 24),
          
          // --- ส่วนที่ 2: รายการ Shelter (Hardcoded) ---
          ShelterCard(
            imageWidget: Image.asset(
              'assets/shelter1.png', 
              fit: BoxFit.cover,
            ),
            title: 'บ้านนางฟ้าของสัตว์จร',
            subtitle: 'จังหวัดสระบุรี',
            shelterId: '00000000-0000-0000-0000-000000000001', // ID สำหรับทดสอบ
          ),
          
          ShelterCard(
            imageWidget: Image.asset(
              'assets/shelter1.png', 
              fit: BoxFit.cover,
            ),
            title: 'มูลนิธิเพื่อสุนัขในซอย',
            subtitle: 'จังหวัดภูเก็ต',
            shelterId: '00000000-0000-0000-0000-000000000002', // ID สำหรับทดสอบ
          ),

          const SizedBox(height: 80), 
        ],
      ),
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
