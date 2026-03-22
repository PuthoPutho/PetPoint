// ไฟล์: lib/main.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../news/news.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentScore = 80; 
  
  // 1. เปลี่ยนตัวแปรมาใช้เช็คสถานะการ Hover (เอาเมาส์ชี้) แทน
  bool _isMegaphoneHovered = false;

  String _getCatImage(int score) {
    if (score >= 0 && score <= 25) {
      return 'assets/Egg.png'; 
    } else if (score >= 26 && score <= 50) {
      return 'assets/OrangeCatBaby.png'; 
    } else {
      return 'assets/OrangeCat.png'; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. สีพื้นหลัง
          Column(
            children: [
              Expanded(
                flex: 6,
                child: Container(color: const Color(0xFFFDF8E7)),
              ), 
              Expanded(
                flex: 4,
                child: Container(color: const Color(0xFFFCE1EB)), 
              ),
            ],
          ),

          // 2. รูปน้องแมว
          Align(
            alignment: const Alignment(0, 0.15), 
            child: Image.asset(
              _getCatImage(currentScore), 
              height: 320, 
              fit: BoxFit.contain,
            ),
          ),

          // 3. ส่วนเนื้อหา
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // -- Header --
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Welcome",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF7F4E29), 
                            ),
                          ),
                          Text(
                            "PunPun",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFEA89A7), 
                            ),
                          ),
                        ],
                      ),
                      
                      // ** จุดที่แก้ไข: ใช้ MouseRegion คลุมเพื่อจับการ Hover **
                      MouseRegion(
                        // เปลี่ยนเคอร์เซอร์เมาส์เป็นรูปนิ้วชี้
                        cursor: SystemMouseCursors.click, 
                        // เมื่อเมาส์ชี้เข้ามาที่ปุ่ม
                        onEnter: (_) {
                          setState(() {
                            _isMegaphoneHovered = true;
                          });
                        },
                        // เมื่อเมาส์เลื่อนออกไปจากปุ่ม
                        onExit: (_) {
                          setState(() {
                            _isMegaphoneHovered = false;
                          });
                        },
                        child: GestureDetector(
                          // ยังคงใช้ onTap เพื่อให้คลิกเปลี่ยนหน้าได้
                          onTap: () {
                            // (ถ้าต้องการให้สีกลับเป็นปกติก่อนเปลี่ยนหน้า เปิดโค้ดด้านล่างนี้ได้ครับ)
                            // setState(() { _isMegaphoneHovered = false; });
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NewsScreen(),
                              ),
                            );
                          },
                          child: AnimatedContainer( 
                            duration: const Duration(milliseconds: 200), // ปรับให้เปลี่ยนสีนุ่มๆ ที่ 200ms
                            decoration: BoxDecoration(
                              // เงื่อนไข: ถ้าเมาส์ชี้ (Hover) ให้ใช้สีเข้ม ถ้าไม่ได้ชี้ให้ใช้สีปกติ
                              color: _isMegaphoneHovered 
                                  ? const Color(0xFFE5C850) // สีเหลืองเข้มตอน Hover
                                  : const Color(0xFFFCE380), // สีปุ่มปกติ
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(12),
                            child: const Icon(
                              LucideIcons.megaphone, 
                              color: Color(0xFF7F4E29),
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ),

                // -- การ์ด Quiz XP --
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 40.0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBCCDF), 
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.pets, 
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Quiz XP",
                                style: TextStyle(
                                  fontFamily: 'GoogleSans',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),

                              Container(
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(2.5), 
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Stack(
                                      children: [
                                        Container(
                                          width: constraints.maxWidth * (currentScore / 100),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFD54F),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            "$currentScore / 100", 
                                            style: const TextStyle(
                                              fontFamily: 'GoogleSans',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF7F4E29),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}