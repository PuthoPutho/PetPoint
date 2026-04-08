import 'package:flutter/material.dart';
import '../screens/shelter/shelter_detail.dart'; 

class ShelterCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String shelterId;
  final String phone;
  final String owner;
  final String details;
  final String imagePath;

  const ShelterCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.shelterId,
    required this.phone,
    required this.owner,
    required this.details,
    required this.imagePath,
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
      
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShelterDetailScreen(
                title: widget.title,
                subtitle: widget.subtitle, 
                shelterId: widget.shelterId,
                phone: widget.phone,
                owner: widget.owner,
                details: widget.details,
                imagePath: widget.imagePath,
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
                  child: widget.imagePath.startsWith('http')
                      ? Image.network(
                          widget.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.pets, color: Colors.grey, size: 50),
                          ),
                        )
                      : Image.asset(
                          widget.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.pets, color: Colors.grey, size: 50),
                          ),
                        ),
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