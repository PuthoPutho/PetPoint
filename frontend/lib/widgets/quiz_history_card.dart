import 'package:flutter/material.dart';

class QuizHistoryCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String score;
  final String points;
  final String imagePath;
  final VoidCallback? onTap;

  const QuizHistoryCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.score,
    required this.points,
    required this.imagePath,
    this.onTap,
  }) : super(key: key);

  @override
  State<QuizHistoryCard> createState() => _QuizHistoryCardState();
}

class _QuizHistoryCardState extends State<QuizHistoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        // --- ส่วนที่แก้ไข: ครอบการ์ดทั้งใบด้วย AnimatedScale ---
        child: AnimatedScale(
          // ขยายขนาดการ์ดทั้งใบ 5% (1.05) เมื่อ Hover
          scale: _isHovered ? 1.0015 : 1.0, 
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut, // ปรับ Curve ให้สมูทขึ้น
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  // ปรับเงาให้เข้มและกระจายมากขึ้นเมื่อ Hover เพื่อให้ดู "ลอย" ขึ้น
                  color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.05),
                  blurRadius: _isHovered ? 16 : 8,
                  spreadRadius: _isHovered ? 2 : 1,
                  offset: Offset(0, _isHovered ? 8 : 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(
                    widget.imagePath,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),

                // ส่วนรายละเอียดด้านล่างภาพ
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'GoogleSans',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.subtitle,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                                fontFamily: 'GoogleSans',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.score,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'GoogleSans',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.points,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontFamily: 'GoogleSans',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}