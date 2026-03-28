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

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.currentUsername);
    if (widget.currentImagePath != null) {
      _pickedImage = File(widget.currentImagePath!);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
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
          icon: Icon(LucideIcons.arrowLeft, color: Colors.black),
          onPressed: () {
            // ย้อนกลับไปยังหน้าโปรไฟล์
            Navigator.pop(context);
          },
        ),
        title: Text("Edit Profile", style: TextStyle(color: Colors.black, fontFamily: 'GoogleSans' , fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300, width: 1.5),
                        ),
                        child: ClipOval(
                          child: _pickedImage != null 
                              ? Image.file(
                                  _pickedImage!,
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
                        right: 4,
                        bottom: 4,
                        child: GestureDetector(
                          onTap: () {
                            // เปิดฟังก์ชันเลือกรูปภาพ
                            _showImagePickerMenu();
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white, // พื้นหลังสีขาว
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300, width: 1.5),
                            ),
                            child: Icon(LucideIcons.camera, color: Color(0xFF59AC77), size: 22),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Username", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'GoogleSans')),
                      SizedBox(height: 12),
                      TextField(
                        controller: _usernameController,
                        style: TextStyle(fontFamily: 'GoogleSans', fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "Your Username",
                          hintStyle: TextStyle(color: Colors.grey[400], fontFamily: 'GoogleSans'),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Color(0xFF59AC77), width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // ดำเนินการบันทึกการเปลี่ยนแปลงและย้อนกลับไปยังหน้าโปรไฟล์
                        Navigator.pop(context, {
                          'username': _usernameController.text,
                          'imagePath': _pickedImage?.path,
                        });
                      },
                      child: Text("Save", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'GoogleSans')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF59AC77), // สีธีมใหม่
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
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