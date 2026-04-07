import 'package:flutter/material.dart';
import 'package:frontend/widgets/shelter_card.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:frontend/services/profile_service.dart';

class ShelterScreen extends StatefulWidget {
  const ShelterScreen({super.key});

  @override
  State<ShelterScreen> createState() => _ShelterScreenState();
}

class _ShelterScreenState extends State<ShelterScreen> {
  List<dynamic> _shelters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShelters();
  }

  Future<void> _loadShelters() async {
    try {
      final data = await UserService.getAllShelters();
      if (mounted) {
        setState(() {
          _shelters = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading shelters: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF67AC7D)))
        : ListView(
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
              
              // --- ส่วนที่ 2: รายการ Shelter จาก Database ---
              if (_shelters.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      'ไม่พบข้อมูลศูนย์พักพิง',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                )
              else
                ..._shelters.map((shelter) {
                  return ShelterCard(
                    imagePath: UserService.getImageUrl(shelter['shelterImage']),
                    title: shelter['name'] ?? 'Unknown Shelter',
                    subtitle: shelter['address'] ?? 'No address',
                    shelterId: shelter['uuid'] ?? '',
                    phone: shelter['phone'] ?? 'No phone',
                    owner: shelter['owner'] ?? 'Unknown owner',
                    details: shelter['details'] ?? 'No details',
                  );
                }).toList(),

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
