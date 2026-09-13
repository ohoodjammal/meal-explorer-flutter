import 'dart:async';
import 'package:flutter/material.dart';
import 'package:final_food/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        SizedBox.expand(
          child: Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.cover,
          ),
        ),

        const Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: CircularProgressIndicator(
              color: Color(0xFFFF6B3D),
            ),
          ),
        ),
      ],
    ),
  );}}