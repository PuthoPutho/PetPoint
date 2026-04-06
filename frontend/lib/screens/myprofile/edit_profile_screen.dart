import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentUsername;
  final String? currentImagePath;

  const EditProfileScreen({
    Key? key,
    required this.currentUsername,
    this.currentImagePath,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _pickedImage;
  late TextEditingController _usernameController;
  
  // 🌟 จุดสำคัญ: ตั้งค่า URL ให้ตรงกับ Backend (ถ้าใช้ Android Emulator ให้เปลี่ยนเป็น 10.0.2.2)
  final String baseUrl = 'http://localhost:3000'; 

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.currentUsername);
    // 💡 หมายเหตุ: เราจะไม่เอา widget.currentImagePath มาใส่ใน File() เพราะมันเป็น Path ของ Server
    // ปล่อย _pickedImage เป็น null ไว้ เพื่อให้ระบบรู้ว่ายังไม่มีการเลือกรูปใหม่จากเครื่อง
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80, 
        maxWidth: 512,  
        maxHeight: 512, 
      );
      if (image == null) return;
      setState(() {
        _pickedImage = File(image.path);
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _showImagePickerMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
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
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Edit Profile", style: TextStyle(color: Colors.black, fontFamily: 'GoogleSans', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, spreadRadius: 2, offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 140, height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300, width: 1.5),
                        ),
                        child: ClipOval(
                          child: _pickedImage != null 
                              // 1. ถ้าเพิ่งเลือกรูปใหม่จาก Gallery/Camera
                              ? Image.file(_pickedImage!, width: 140, height: 140, fit: BoxFit.cover)
                              
                              //  2. ถ้ายังไม่เลือกใหม่ แต่มีรูปเดิมจาก Server ส่งมา
                              : (widget.currentImagePath != null && widget.currentImagePath!.isNotEmpty && widget.currentImagePath != "null")
                                  ? Image.network(
                                      '$baseUrl${widget.currentImagePath}',
                                      width: 140, height: 140, fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => Image.asset('assets/OrangeCat.png', fit: BoxFit.cover),
                                    )
                                  
                                  // 3. ถ้าไม่มีรูปเลย
                                  : Image.asset('assets/OrangeCat.png', width: 140, height: 140, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        right: 4, bottom: 4,
                        child: GestureDetector(
                          onTap: _showImagePickerMenu,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300, width: 1.5),
                            ),
                            child: const Icon(LucideIcons.camera, color: Color(0xFF59AC77), size: 22),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Username", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'GoogleSans')),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _usernameController,
                        style: const TextStyle(fontFamily: 'GoogleSans', fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "Your Username",
                          hintStyle: TextStyle(color: Colors.grey[400], fontFamily: 'GoogleSans'),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade300)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF59AC77), width: 1.5)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        //  ส่งข้อมูลกลับไปที่หน้า Profile
                        Navigator.pop(context, {
                          'username': _usernameController.text,
                          // ถ้าเลือกรูปใหม่ ให้ส่ง Path ในเครื่องไป ถ้าไม่เลือก ให้ส่ง Path เดิมจาก Server กลับไป
                          'imagePath': _pickedImage?.path ?? widget.currentImagePath,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF59AC77),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text("Save", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'GoogleSans')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}