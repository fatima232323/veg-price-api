import 'package:flutter/material.dart';
import 'package:servicehub/homescreen/homescreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInSignUpScreen(),
    );
  }
}

class SignInSignUpScreen extends StatefulWidget {
  @override
  _SignInSignUpScreenState createState() => _SignInSignUpScreenState();
}

class _SignInSignUpScreenState extends State<SignInSignUpScreen> {
  bool isSignIn = true;
  String? selectedGender;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F1E5), // Ensure pure white background
      body: Column(
        children: [
          // Image takes half the screen
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Color(0xFFF8F1E5),
              child: Image.asset(
                'assets/biker.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Sign-in/sign-up section
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => isSignIn = true),
                          child: Text("Sign In",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSignIn ? Colors.brown : Colors.black)),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => isSignIn = false),
                          child: Text("Sign Up",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      !isSignIn ? Colors.brown : Colors.black)),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    if (!isSignIn) ...[
                      _buildTextField("First Name", Icons.person),
                      _buildTextField("Last Name", Icons.person),
                      _buildTextField("Email Address (Optional)", Icons.email),
                    ],
                    _buildTextField("Phone Number", Icons.phone,
                        controller: _phoneController),
                    _buildTextField("Password", Icons.lock,
                        obscureText: true, controller: _passwordController),
                    if (!isSignIn) ...[
                      _buildTextField("Confirm Password", Icons.lock,
                          obscureText: true,
                          controller: _confirmPasswordController),
                      SizedBox(height: 10),
                      // Gender Selection
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text("Gender: ", style: TextStyle(fontSize: 14)),
                            Row(
                              children: [
                                Radio(
                                  value: "Male",
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value.toString();
                                    });
                                  },
                                ),
                                Text("Male"),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: "Female",
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value.toString();
                                    });
                                  },
                                ),
                                Text("Female"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to HomeScreen when Sign In or Create Account is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(isSignIn ? "Sign In" : "Create Account"),
                    ),
                    if (isSignIn) ...[
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.center,
                        child: Text("Forgot Password?",
                            style: TextStyle(color: Colors.brown)),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon,
      {bool obscureText = false, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.brown), // Brown icon
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.brown, width: 2), // Brown border when active
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.brown, width: 1.5), // Brown border when inactive
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
