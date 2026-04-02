import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spider_chart/spider_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'edit_profile_screen.dart'; 

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = "PunPun";
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

            SizedBox(height: 20),
            Text("Profile", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'GoogleSans',)),
            SizedBox(height: 30),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: _imagePath != null
                        ? Image.file(
                            File(_imagePath!),
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/OrangeCat.png', // เปลี่ยนเป็นรูปภาพที่มีอยู่แล้วในโปรเจกต์
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: GestureDetector(
                    onTap: () async {
                      // นำทางไปยังหน้าแก้ไขโปรไฟล์
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            currentUsername: _username,
                            currentImagePath: _imagePath,
                          ),
                        ),
                      );

                      if (result != null && result is Map) {
                        setState(() {
                          _username = result['username'] ?? _username;
                          _imagePath = result['imagePath'] ?? _imagePath;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white, // สีเขียวอ่อน
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                      ),
                      child: Icon(LucideIcons.pencil, color: Color(0xFF59AC77), size: 20),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Text(_username, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'GoogleSans')),
            SizedBox(height: 5),
            Text("PunKung@gmail.com", style: TextStyle(color: Colors.grey[600], fontSize: 14, fontFamily: 'GoogleSans')),
            SizedBox(height: 30),
            _buildRadarChartCard(),
            SizedBox(height: 30),
            _buildSettingsList(),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildRadarChartCard() {
    return Container(
      width: 320,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Center(
          child: SpiderChart(
            data: const [
              18.0, // Grammar
              14.0, // Vocab
              16.0, // Conversation
              12.0, // Sentence
              15.0, // Meaning
            ],
            maxValue: 20, // คะแนนเต็ม 20
            colors: const [
              Color(0xFF59AC77),
              Color(0xFF59AC77),
              Color(0xFF59AC77),
              Color(0xFF59AC77),
              Color(0xFF59AC77),
            ],
            labels: const [
              'Grammar',
              'Vocab',
              'Conversation',
              'Sentence',
              'Meaning'
            ],
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
          _buildSettingsItem(LucideIcons.bell, "Notification", trailing: const AnimatedCustomSwitch(initialValue: true)),
          _buildSettingsItem(LucideIcons.settings, "Setting", trailing: Icon(LucideIcons.chevronRight, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, {Widget? trailing}) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        leading: Icon(icon, color: Colors.grey[600], size: 28),
        title: Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'GoogleSans')),
        trailing: trailing,
      ),
    );
  }

}

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
        setState(() {
          _value = !_value;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(_value);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 62,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _value ? const Color(0xFF59AC77) : Colors.grey.shade300,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              top: 2,
              bottom: 2,
              left: _value ? 32 : 2,
              right: _value ? 2 : 32,
              child: Container(
                width: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 0.5),
                  ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}