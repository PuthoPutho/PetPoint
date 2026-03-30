
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

        
          Align(
            alignment: const Alignment(0, 0.15), 
            child: Image.asset(
              _getCatImage(currentScore), 
              height: 320, 
              fit: BoxFit.contain,
            ),
          ),

          
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
                      
                     
                      MouseRegion(
                        
                        cursor: SystemMouseCursors.click, 
                        
                        onEnter: (_) {
                          setState(() {
                            _isMegaphoneHovered = true;
                          });
                        },
                        
                        onExit: (_) {
                          setState(() {
                            _isMegaphoneHovered = false;
                          });
                        },
                        child: GestureDetector(
                          
                          onTap: () {
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NewsScreen(),
                              ),
                            );
                          },
                          child: AnimatedContainer( 
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              
                              color: _isMegaphoneHovered 
                                  ? const Color(0xFFE5C850) 
                                  : const Color(0xFFFCE380), 
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

                // -- Quiz XP --
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