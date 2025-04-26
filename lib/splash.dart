import 'package:flutter/material.dart';
import 'package:servicehub/welcome.dart'; // Import your WelcomeScreen here
import 'dart:async';
import 'dart:ui';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  List<String> words = ["Services", "at", "your", "doorstep"];
  int wordIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  Timer? _wordTimer;

  @override
  void initState() {
    super.initState();

    // Start fade-in animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();

    // Show words one by one
    _wordTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (wordIndex < words.length - 1) {
        setState(() {
          wordIndex++;
        });
      } else {
        timer.cancel();
      }
    });

    // Navigate to WelcomeScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(customerName: 'Guest'),
        ),
      );
    });
  }

  @override
  void dispose() {
    _wordTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/logo.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Blurred Background
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
          ),

          // Animated Text
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                words.sublist(0, wordIndex + 1).join(" "),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.brown,
                  fontFamily: 'DancingScript',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
