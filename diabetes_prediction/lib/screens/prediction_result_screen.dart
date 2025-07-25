import 'package:flutter/material.dart';

class PredictionResultScreen extends StatefulWidget {
  final String predictionResult;

  const PredictionResultScreen({super.key, required this.predictionResult});

  @override
  State<PredictionResultScreen> createState() => _PredictionResultScreenState();
}

class _PredictionResultScreenState extends State<PredictionResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDiabetic = widget.predictionResult == 'Diabetic';
    final Color displayColor = isDiabetic
        ? Colors.red[700]!
        : Colors.green[700]!;
    final IconData displayIcon = isDiabetic
        ? Icons.sentiment_dissatisfied
        : Icons.sentiment_satisfied;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prediction Result',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _animation,
                    child: FadeTransition(
                      opacity: _animation,
                      child: Icon(
                        displayIcon,
                        color: displayColor,
                        size: 100.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _animation,
                    child: Text(
                      'Your Prediction Is:',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ScaleTransition(
                    scale: _animation,
                    child: Text(
                      widget.predictionResult,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: displayColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Go back to prediction screen
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    label: const Text(
                      'Go Back',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
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
