import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'edit_profile_screen.dart'; // Import หน้าแก้ไขโปรไฟล์

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                    child: Image.asset(
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
                    onTap: () {
                      // นำทางไปยังหน้าแก้ไขโปรไฟล์
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfileScreen()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xFF59AC77), // สีเขียวอ่อน
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(LucideIcons.pencil, color: Colors.white, size: 20),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Text("PunPun", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'GoogleSans')),
            SizedBox(height: 5),
            Text("PunKung@gmail.com", style: TextStyle(color: Colors.grey[600], fontSize: 14, fontFamily: 'GoogleSans')),
            SizedBox(height: 30),
            _buildRadarChartCard(),
            SizedBox(height: 30),
            _buildSettingsList(),
          ],
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
        padding: const EdgeInsets.all(16.0),
        child: RadarChart(
          RadarChartData(
          // กำหนดข้อมูลระดับทักษะสำหรับแต่ละแกน (เช่น 5 แกน)
          dataSets: [
            RadarDataSet(
              fillColor: Color(0xFFE8F5E9), // สีเขียวอ่อนสุดๆ
              borderColor: Color(0xFF59AC77), // สีเขียวอ่อน
              entryRadius: 0,
              dataEntries: [
                RadarEntry(value: 18), // ตัวอย่างคะแนน (ปรับให้ไม่เกิน 20)
                RadarEntry(value: 14),
                RadarEntry(value: 16),
                RadarEntry(value: 12),
                RadarEntry(value: 15),
              ],
            ),
            // ข้อมูลจำลองที่โปร่งใสเพื่อขยายขอบเขตของ Chart ให้ครอบคลุมมากขึ้น
            RadarDataSet(
              fillColor: Colors.transparent,
              borderColor: Colors.transparent,
              entryRadius: 0,
              dataEntries: [
                RadarEntry(value: 20), // คะแนนสูงสุดคือ 20
                RadarEntry(value: 20),
                RadarEntry(value: 20),
                RadarEntry(value: 20),
                RadarEntry(value: 20),
              ],
            ),
          ],
          radarShape: RadarShape.polygon,
          radarBackgroundColor: Colors.white,
          borderData: FlBorderData(show: false),
          radarBorderData: const BorderSide(color: Colors.transparent),
          titlePositionPercentageOffset: 0.1,
          titleTextStyle: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'GoogleSans'),
          // กำหนดป้ายกำกับแกน
          getTitle: (index, angle) {
            switch (index) {
              case 0:
                return RadarChartTitle(text: 'Grammar');
              case 1:
                return RadarChartTitle(text: 'Vocab');
              case 2:
                return RadarChartTitle(text: 'Conversation');
              case 3:
                return RadarChartTitle(text: 'Sentence');
              case 4:
                return RadarChartTitle(text: 'Meaning');
              default:
                return const RadarChartTitle(text: '');
            }
          },
          tickCount: 4,
          ticksTextStyle: const TextStyle(color: Colors.transparent, fontFamily: 'GoogleSans'),
          tickBorderData: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1.5),
          gridBorderData: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1.5),
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