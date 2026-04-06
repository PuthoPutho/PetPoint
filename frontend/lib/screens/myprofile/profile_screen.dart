import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spider_chart/spider_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/profile_service.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = "Loading...";
  String _email = "Loading...";
  String? _imagePath;
  bool isLoading = true;

  List<double> spiderData = [0, 0, 0, 0, 0];
  List<String> spiderLabels = ['Grammar', 'Vocabulary', 'Reading', 'Sentence', 'Meaning'];

  final String myUserId = '85243aaf-423b-4da0-8bf6-6336ab35fbff';
  final String baseUrl = 'http://192.168.1.40:3000';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    if (mounted) setState(() => isLoading = true);

    try {
      final results = await Future.wait([
        UserService.getUserProfile(myUserId),
        UserService.getSpiderChartData(myUserId),
      ]);

      final userData = results[0] as Map<String, dynamic>?;
      final chartData = results[1] as List<dynamic>? ?? [];

      if (mounted) {
        setState(() {
          if (userData != null) {
            print('🔍 Check User Data from DB: $userData'); // 🌟 ดูตรงนี้ใน Console ว่า image มาไหม
            _username = userData['username'] ?? 'No Name';
            _email = userData['email'] ?? 'No Email';
            
            // เช็คว่ามี Path รูปมาจริงๆ ไหม
            var rawImage = userData['profileImage'];
            _imagePath = (rawImage != null && rawImage.toString().isNotEmpty && rawImage != "null") 
                         ? rawImage.toString() 
                         : null;
          }

          if (chartData.isNotEmpty) {
            Map<String, Map<String, double>> latestScores = {
              'grammar': {}, 'vocab': {}, 'reading': {}, 'sentence': {}, 'meaning': {}
            };

            for (var item in chartData) {
              String qId = (item['quizId'] ?? item['quiz_id'] ?? item['uizId'] ?? '').toString();
              String cat = (item['category'] ?? '').toString().toLowerCase();
              double score = double.tryParse(item['score'].toString()) ?? 0;

              String mappedCat = '';
              if (cat.contains('grammar')) mappedCat = 'grammar';
              else if (cat.contains('vocab')) mappedCat = 'vocab';
              else if (cat.contains('reading')) mappedCat = 'reading';
              else if (cat.contains('sentence')) mappedCat = 'sentence';
              else if (cat.contains('meaning')) mappedCat = 'meaning';

              if (mappedCat.isNotEmpty && qId.isNotEmpty) {
                latestScores[mappedCat]![qId] = score;
              }
            }

            spiderData[0] = latestScores['grammar']!.values.fold(0.0, (p, c) => p + c).clamp(0.0, 20.0);
            spiderData[1] = latestScores['vocab']!.values.fold(0.0, (p, c) => p + c).clamp(0.0, 20.0);
            spiderData[2] = latestScores['reading']!.values.fold(0.0, (p, c) => p + c).clamp(0.0, 20.0);
            spiderData[3] = latestScores['sentence']!.values.fold(0.0, (p, c) => p + c).clamp(0.0, 20.0);
            spiderData[4] = latestScores['meaning']!.values.fold(0.0, (p, c) => p + c).clamp(0.0, 20.0);
          }
          isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading data: $e');
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF59AC77))));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text("Profile", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'GoogleSans')),
              const SizedBox(height: 30),
              
              // ส่วนแสดงรูปภาพโปรไฟล์
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[100],
                   //  เปลี่ยนจากเดิมที่เชื่อม $baseUrl เสมอ เป็นการเช็คเงื่อนไขก่อน
child: ClipOval(
  child: (_imagePath != null && _imagePath != "")
      ? (_imagePath!.startsWith('http') 
          //  ถ้าเป็นลิงก์เน็ต (https://...) ให้ใช้ตรงๆ ได้เลย
          ? Image.network(
              _imagePath!, 
              width: 140, height: 140, fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Image.asset('assets/OrangeCat.png'),
            )
          //  ถ้าเริ่มต้นด้วย /uploads ให้ต่อ baseUrl ปกติ
          : Image.network(
              '$baseUrl$_imagePath',
              width: 140, height: 140, fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Image.asset('assets/OrangeCat.png'),
            ))
      : Image.asset('assets/OrangeCat.png', width: 140, height: 140, fit: BoxFit.cover),
),
                  ),
                  Positioned(
                    right: 10, bottom: 10,
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(context, MaterialPageRoute(
                          builder: (context) => EditProfileScreen(currentUsername: _username, currentImagePath: _imagePath),
                        ));

                        if (result != null && result is Map) {
                          setState(() => isLoading = true);
                          final newName = result['username'];
                          final newPath = result['imagePath'];
                          
                          File? fileToUpload = (newPath != null && newPath != _imagePath) ? File(newPath) : null;
                          bool success = await UserService.updateProfile(myUserId, newName, fileToUpload);

                          if (success) {
                            await _loadProfileData(); // โหลดใหม่จาก Backend เพื่อความชัวร์
                          } else {
                            setState(() => isLoading = false);
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300, width: 2)),
                        child: const Icon(LucideIcons.pencil, color: Color(0xFF59AC77), size: 20),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Text(_username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'GoogleSans')),
              Text(_email, style: TextStyle(color: Colors.grey[600], fontSize: 14, fontFamily: 'GoogleSans')),
              const SizedBox(height: 30),
              _buildRadarChartCard(),
              const SizedBox(height: 30),
              _buildSettingsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadarChartCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: 320,
              height: 320,
              child: SpiderChart(
                data: spiderData,
                maxValue: 20,
                colors: const [Color(0xFF59AC77), Color(0xFF59AC77), Color(0xFF59AC77), Color(0xFF59AC77), Color(0xFF59AC77)],
                labels: spiderLabels,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildSettingsItem(
            LucideIcons.bell, 
            "Notification", 
            trailing: AnimatedCustomSwitch(initialValue: true, onChanged: (v) => print("Notify: $v")), // 🌟 ลบ const ออกแล้ว
          ),
          _buildSettingsItem(
            LucideIcons.settings, 
            "Setting", 
            trailing: const Icon(LucideIcons.chevronRight, color: Colors.grey)
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, {Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.grey.shade300, width: 1.5)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        leading: Icon(icon, color: Colors.grey[600], size: 28),
        title: Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'GoogleSans')),
        trailing: trailing,
      ),
    );
  }
}

// 🌟 ตัวคลาส AnimatedCustomSwitch ต้องอยู่นอกคลาสหลักแบบนี้ครับ
class AnimatedCustomSwitch extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const AnimatedCustomSwitch({Key? key, this.initialValue = true, this.onChanged}) : super(key: key);

  @override
  _AnimatedCustomSwitchState createState() => _AnimatedCustomSwitchState();
}

class _AnimatedCustomSwitchState extends State<AnimatedCustomSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _value = !_value);
        if (widget.onChanged != null) widget.onChanged!(_value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 62, height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _value ? const Color(0xFF59AC77) : Colors.grey.shade300,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              top: 2, left: _value ? 32 : 2,
              child: Container(
                width: 28, height: 28,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}