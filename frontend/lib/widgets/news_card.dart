import 'package:flutter/material.dart';

class NewsCard extends StatefulWidget { // เปลี่ยนเป็น StatefulWidget เพื่อเก็บสถานะ Hover
  final String title;
  final String description;
  final String content;
  final String imagePath;

  const NewsCard({
    super.key,
    required this.title,
    required this.description,
    required this.content,
    required this.imagePath,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool _isHovered = false; // ตัวแปรเก็บสถานะว่าเมาส์ชี้อยู่หรือไม่

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFFF7F0E5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF62B179),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            const Positioned(top: 15, left: 15, child: Icon(Icons.star, color: Colors.white, size: 14)),
                            const Positioned(top: 15, right: 15, child: Icon(Icons.star, color: Colors.white, size: 14)),
                            const Center(
                              child: Text(
                                "New\nCharacter",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFFCE380),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 28,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              bottom: 0,
                              child: Image.asset(widget.imagePath, height: 110),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 5),
                      Text(widget.description, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 15),
                      Text(
                        widget.content,
                        style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.close, color: Color(0xFFBDBDBD), size: 24),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // เปลี่ยนเป็นรูปนิ้วชี้เมื่อ Hover
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => _showDetails(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(bottom: 20),
          // --- เอฟเฟกต์การ Hover ---
          transform: _isHovered 
              ? (Matrix4.identity()..scale(1.0015)) 
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.05), // เงาเข้มขึ้นตอน Hover
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 10 : 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 160,
                decoration: const BoxDecoration(
                  color: Color(0xFF62B179),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Text(
                        "New\nCharacter",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFCE380),
                          fontWeight: FontWeight.w900,
                          fontSize: 32,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Positioned(right: 10, bottom: 0, child: Image.asset(widget.imagePath, height: 120)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(widget.description, style: const TextStyle(color: Colors.black87, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}