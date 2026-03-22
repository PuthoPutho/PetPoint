import 'package:flutter/material.dart';
import '../screens/shelter/shelter_detail.dart'; 

class ShelterCard extends StatefulWidget {
  final Widget imageWidget;
  final String title;
  final String subtitle;

  const ShelterCard({
    super.key,
    required this.imageWidget,
    required this.title,
    required this.subtitle,
  });

  @override
  State<ShelterCard> createState() => _ShelterCardState();
}

class _ShelterCardState extends State<ShelterCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) => setState(() => _isHovered = false),
        onTapCancel: () => setState(() => _isHovered = false),
        onTap: () {
          // --- เมื่อกดการ์ด จะไปยังหน้า ShelterDetailScreen ---
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShelterDetailScreen(
                title: widget.title,
                subtitle: widget.subtitle, // ส่ง subtitle ไปเพื่อแก้ Error
              ),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20),
          transform: _isHovered 
              ? (Matrix4.identity()..scale(1.0015))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.05),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 10 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: widget.imageWidget,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
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