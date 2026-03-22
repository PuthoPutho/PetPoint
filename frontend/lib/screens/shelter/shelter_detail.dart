import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ShelterDetailScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const ShelterDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    this.imagePath = 'assets/shelter1.png', // เปลี่ยนเป็น path รูปของคุณ
  });

  // --- ฟังก์ชันสำหรับแสดง Popup ยืนยัน ---
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
                  child: Image.asset(
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

                // นำตัวแปร subtitle มาแสดงผลตรงนี้
                _buildInfoRow(icon: LucideIcons.mapPin, text: subtitle),
                _buildInfoRow(
                  icon: LucideIcons.user,
                  text: 'คุณอนงค์เนตร สิทธิกาล (คุณป้าต่าย)',
                ),
                _buildInfoRow(
                  icon: Icons.pets,
                  text: 'สุนัขและแมวดูแลกว่า 2,000+ ตัว',
                ),
                _buildInfoRow(
                  icon: LucideIcons.facebook,
                  text: 'บ้านนางฟ้าของสัตว์จร (@CHSAThai)',
                ),
                _buildInfoRow(icon: LucideIcons.phone, text: '089 099 6000'),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // กดแล้วเรียก Popup
                      _showSuccessDialog(context);
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
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   selectedItemColor: const Color(0xFF67AC7D),
      //   unselectedItemColor: Colors.grey,
      //   showSelectedLabels: true,
      //   showUnselectedLabels: true,
      //   currentIndex: 0,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Foster'),
      //     BottomNavigationBarItem(icon: Icon(LucideIcons.trophy), label: 'Score'),
      //     BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(LucideIcons.bookOpen), label: 'Quiz'),
      //     BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: 'Profile'),
      //   ],
      // ),
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
