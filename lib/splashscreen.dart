import 'package:flutter/material.dart';
import 'dart:async';
import 'homepage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with Opacity
          Opacity(
            opacity: 0.6,
            child: Image.asset(
              "Assets/images/background.jpg", // ✅ check lowercase path
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Logo and Title
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "Assets/images/splash_logo.png", // ✅ corrected path casing
                  width: 400,
                  height: 400,
                ),
                SizedBox(height: 20),
                Text(
                  "Music",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Consider making this white for contrast
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
