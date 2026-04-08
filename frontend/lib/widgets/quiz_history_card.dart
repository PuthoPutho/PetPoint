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
        
        child: AnimatedScale(
          
          scale: _isHovered ? 1.0015 : 1.0, 
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut, 
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
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
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: _buildImage(widget.imagePath),
                ),

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

  Widget _buildImage(String path) {
    //  Helper สำหรับตัดสินใจว่าจะใช้ Image.network หรือ Image.asset
    const String serverUrl = 'http://localhost:3000'; // ถ้าขึ้น Production ต้องแก้ตรงนี้
    
    if (path.isEmpty) {
      return Container(
        height: 180, width: double.infinity, color: Colors.grey[200],
        child: const Icon(Icons.quiz_outlined, size: 40, color: Colors.grey),
      );
    }

    if (path.startsWith('http') || path.startsWith('https')) {
      return Image.network(path, height: 180, width: double.infinity, fit: BoxFit.cover, 
        errorBuilder: (c, e, s) => _buildErrorPlaceholder());
    }

    if (path.startsWith('/uploads')) {
      return Image.network('$serverUrl$path', height: 180, width: double.infinity, fit: BoxFit.cover, 
        errorBuilder: (c, e, s) => _buildErrorPlaceholder());
    }

    // กรณีเป็น Local Asset
    return Image.asset(path, height: 180, width: double.infinity, fit: BoxFit.cover, 
      errorBuilder: (c, e, s) => _buildErrorPlaceholder());
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      height: 180, width: double.infinity, color: Colors.grey[300],
      child: const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey)),
    );
  }
}