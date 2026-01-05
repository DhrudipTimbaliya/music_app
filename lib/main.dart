import 'package:flutter/material.dart';
import 'dart:async';
import 'splashscreen.dart';
import 'homepage.dart';

void main() {

  runApp(MyApp());
}

// Root app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material Demo',
      debugShowCheckedModeBanner: false, // 🚀 removes debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: SplashScreen(), // Start with splash
    );
  }
}

