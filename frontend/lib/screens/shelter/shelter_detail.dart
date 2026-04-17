import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/auth_provider.dart';
import '../../services/profile_service.dart';

class ShelterDetailScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final String shelterId;
  final String phone;
  final String owner;
  final String details;

  const ShelterDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.shelterId,
    required this.phone,
    required this.owner,
    required this.details,
    this.imagePath = 'assets/shelter1.png', 
  });
  
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(), // ปิด popup
                    child: const Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Icon(Icons.pets, size: 90, color: Color(0xFF5AAB73)),
                const SizedBox(height: 24),
                const Text(
                  'Donation successful',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5AAB73),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Thank you for your donation!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            LucideIcons.chevronLeft,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imagePath.startsWith('http') 
                    ? Image.network(
                        imagePath,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: double.infinity,
                          height: 180,
                          color: Colors.grey.shade300,
                          child: const Icon(
                            LucideIcons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Image.asset(
                        imagePath,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: double.infinity,
                          height: 180,
                          color: Colors.grey.shade300,
                          child: const Icon(
                            LucideIcons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),

                
                _buildInfoRow(icon: LucideIcons.mapPin, text: subtitle),
                _buildInfoRow(
                  icon: LucideIcons.user,
                  text: owner,
                ),
                _buildInfoRow(
                  icon: Icons.pets,
                  text: details,
                ),
                _buildInfoRow(icon: LucideIcons.phone, text: phone),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final auth = AuthProvider.of(context);
                      final userId = auth.userId ?? '';

                      if (userId.isEmpty) return;

                      
                      if (auth.currentScore < 100) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('คะแนนไม่เพียงพอสำหรับการบริจาค (ต้องการ 100 Points)')),
                        );
                        return;
                      }

                    
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (ctx) => const Center(child: CircularProgressIndicator(color: Color(0xFF5AAB73))),
                      );

                      
                      final result = await UserService.donateToShelter(userId, shelterId, 100);

                      if (!context.mounted) return;
                      Navigator.pop(context); 

                      if (result != null) {
                   
                        auth.updateScore(
                          int.parse(result['newScore'].toString()), 
                          donatedScore: int.parse(result['donatedTotal'].toString())
                        );

                   
                        _showSuccessDialog(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('การบริจาคล้มเหลว กรุณาลองใหม่อีกครั้ง')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5AAB73),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF5AAB73), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
