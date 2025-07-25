import 'package:flutter/material.dart';
import 'package:diabetes_prediction/screens/animated_intro_screen.dart';
import 'package:diabetes_prediction/utils/custom_page_route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToIntro();
  }

  _navigateToIntro() async {
    await Future.delayed(
      const Duration(milliseconds: 2000),
      () {},
    ); // Splash screen duration
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      CustomPageRoute(child: const AnimatedIntroScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.monitor_heart, color: Colors.white, size: 100.0),
            SizedBox(height: 20),
            Text(
              'Diabetes Predictor',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
