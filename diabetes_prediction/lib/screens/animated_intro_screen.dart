import 'package:flutter/material.dart';
import 'package:diabetes_prediction/screens/diabetes_prediction_screen.dart';
import 'package:diabetes_prediction/utils/custom_page_route.dart';

class AnimatedIntroScreen extends StatefulWidget {
  const AnimatedIntroScreen({super.key});

  @override
  State<AnimatedIntroScreen> createState() => _AnimatedIntroScreenState();
}

class _AnimatedIntroScreenState extends State<AnimatedIntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: Icon(
                    Icons.health_and_safety,
                    color: Colors.blueAccent,
                    size: 150.0,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              FadeTransition(
                opacity: _opacityAnimation,
                child: const Text(
                  'Understand Your Health Better',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              FadeTransition(
                opacity: _opacityAnimation,
                child: Text(
                  'Predict your diabetes risk with intelligent analysis based on your health metrics.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                ),
              ),
              const SizedBox(height: 50),
              SlideTransition(
                position: _slideAnimation,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      CustomPageRoute(child: const DiabetesPredictionScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Start Prediction',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
