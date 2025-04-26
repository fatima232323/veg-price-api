import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/worker2.jpeg', // Replace with your background image
              fit: BoxFit.cover,
            ),
          ),

          // Swipable White Container with Enhanced Aesthetic Edges
          DraggableScrollableSheet(
            initialChildSize: 0.60, // Moved slightly upward
            minChildSize: 0.60, // Minimum height
            maxChildSize: 0.85, // Maximum height
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      spreadRadius: 3,
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Please enter your details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),

                      // Text Fields
                      _buildTextField(Icons.person, "Full Name"),
                      _buildTextField(Icons.phone, "Phone Number"),
                      _buildTextField(Icons.email, "Email Address (Optional)"),
                      _buildTextField(Icons.credit_card, "CNIC"),

                      // Gender Selection
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Gender: ", style: TextStyle(fontSize: 16)),
                          SizedBox(width: 10),
                          ChoiceChip(
                              label: Text("Male"),
                              selected: false,
                              onSelected: (val) {}),
                          SizedBox(width: 10),
                          ChoiceChip(
                              label: Text("Female"),
                              selected: false,
                              onSelected: (val) {}),
                        ],
                      ),
                      SizedBox(height: 15),

                      // Photo Upload
                      GestureDetector(
                        onTap: _pickImage,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, color: Colors.grey),
                            SizedBox(width: 8),
                            Text("Upload Photo (Mandatory)",
                                style: TextStyle(color: Colors.grey[700]))
                          ],
                        ),
                      ),
                      if (_image != null)
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Image.file(_image!, height: 50, width: 50),
                        ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.brown),
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.brown, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.brown, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
        ),
      ),
    );
  }
}
