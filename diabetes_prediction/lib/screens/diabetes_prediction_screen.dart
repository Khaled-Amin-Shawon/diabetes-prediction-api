import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:diabetes_prediction/services/api_service.dart';
import 'package:diabetes_prediction/screens/prediction_result_screen.dart';

class DiabetesPredictionScreen extends StatefulWidget {
  const DiabetesPredictionScreen({super.key});

  @override
  State<DiabetesPredictionScreen> createState() =>
      _DiabetesPredictionScreenState();
}

class _DiabetesPredictionScreenState extends State<DiabetesPredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pregnanciesController = TextEditingController();
  final TextEditingController _glucoseController = TextEditingController();
  final TextEditingController _bloodPressureController =
      TextEditingController();
  final TextEditingController _skinThicknessController =
      TextEditingController();
  final TextEditingController _insulinController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();
  final TextEditingController _diabetesPedigreeController =
      TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // Removed _predictionResult here as it will be passed to a new screen
  bool _isLoading = false;

  @override
  void dispose() {
    _pregnanciesController.dispose();
    _glucoseController.dispose();
    _bloodPressureController.dispose();
    _skinThicknessController.dispose();
    _insulinController.dispose();
    _bmiController.dispose();
    _diabetesPedigreeController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _predictDiabetes() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Parse input values
      final List<double> features = [
        double.parse(_pregnanciesController.text),
        double.parse(_glucoseController.text),
        double.parse(_bloodPressureController.text),
        double.parse(_skinThicknessController.text),
        double.parse(_insulinController.text),
        double.parse(_bmiController.text),
        double.parse(_diabetesPedigreeController.text),
        double.parse(_ageController.text),
      ];

      try {
        final prediction = await ApiService.predictDiabetes(features);
        if (kDebugMode) {
          print('API Prediction Result: $prediction');
        }
        final String resultText = prediction == 1 ? 'Diabetic' : 'Not Diabetic';

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PredictionResultScreen(predictionResult: resultText),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        // Show error using a SnackBar or AlertDialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Diabetes Prediction',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Enter Patient Health Metrics',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _buildTextFormField(
                    _pregnanciesController,
                    'Pregnancies',
                    Icons.pregnant_woman,
                    isInt: true,
                  ),
                  _buildTextFormField(
                    _glucoseController,
                    'Glucose',
                    Icons.bloodtype,
                  ),
                  _buildTextFormField(
                    _bloodPressureController,
                    'Blood Pressure',
                    Icons.monitor_heart,
                  ),
                  _buildTextFormField(
                    _skinThicknessController,
                    'Skin Thickness',
                    Icons.straighten,
                  ),
                  _buildTextFormField(
                    _insulinController,
                    'Insulin',
                    Icons.opacity,
                  ),
                  _buildTextFormField(_bmiController, 'BMI', Icons.scale),
                  _buildTextFormField(
                    _diabetesPedigreeController,
                    'Diabetes Pedigree Function',
                    Icons.family_restroom,
                  ),
                  _buildTextFormField(
                    _ageController,
                    'Age',
                    Icons.perm_identity,
                    isInt: true,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _predictDiabetes,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.analytics_outlined,
                            color: Colors.white,
                          ),
                    label: Text(
                      _isLoading ? 'Predicting...' : 'Predict Diabetes',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                    ),
                  ),
                  // Removed prediction result display from this screen
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String labelText,
    IconData icon, {
    bool isInt = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isInt
            ? TextInputType.number
            : TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.blue[50],
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blue.shade100, width: 1.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          if (isInt) {
            if (int.tryParse(value) == null) {
              return 'Please enter a valid integer for $labelText';
            }
          } else {
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number for $labelText';
            }
          }
          return null;
        },
      ),
    );
  }
}
