# Diabetes Prediction Project

An end-to-end machine learning project for predicting diabetes, including data preprocessing, model training (SVM, Random Forest, Logistic Regression, Decision Tree), API development using Flask, hosting on Render, and a Flutter mobile application for integration.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Local Setup (Model Training)](#local-setup-model-training)
- [API Development](#api-development)
- [Hosting on Render](#hosting-on-render)
- [Flutter Integration](#flutter-integration)
- [Usage](#usage)
- [Future Improvements](#future-improvements)

---

## Project Overview

This project aims to predict the likelihood of diabetes in patients based on several diagnostic measurements. It involves:

- Data loading and preprocessing (handling missing values, standardization).
- Training and evaluating multiple machine learning models (SVM, Random Forest, Logistic Regression, Decision Tree).
- Comparing model performance using accuracy, precision, recall, and F1-score.
- Developing a RESTful API using Flask to serve predictions.
- Deploying the API to a cloud platform (Render).
- Integrating the prediction functionality into a cross-platform mobile application built with Flutter.

---

## Local Setup (Model Training)

This section guides you through setting up the environment and running the Jupyter Notebook for model training and evaluation.

### Prerequisites (পূর্বশর্ত)

Make sure you have Python installed. We recommend using `Anaconda` or `Miniconda` for environment management.

1.  **Python 3.x**
2.  **pip** (Python package installer)

### Installation (ইনস্টলেশন)

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/your-username/diabetes-prediction.git
    cd diabetes-prediction
    ```

    (Replace `your-username/diabetes-prediction` with your actual repository URL)

2.  **Create a virtual environment (recommended):**

    ```bash
    python -m venv venv
    # On Windows
    .\venv\Scripts\activate
    # On macOS/Linux
    source venv/bin/activate
    ```

3.  **Install the required Python packages:**
    ```bash
    pip install pandas numpy scikit-learn matplotlib
    ```
    (You might need `ipykernel` for Jupyter: `pip install ipykernel`)

### Running the Jupyter Notebook (জুপিটার নোটবুক চালানো)

The core machine learning logic is in `Diabetes_Prediction.ipynb`.

1.  **Start Jupyter Notebook:**
    ```bash
    jupyter notebook
    ```
2.  Your web browser will open with the Jupyter interface. Navigate to and open `Diabetes_Prediction.ipynb`.
3.  Run all cells in the notebook sequentially to:
    - Load the `diabetes.csv` dataset.
    - Perform data cleaning (e.g., replacing zero values with median).
    - Standardize the data.
    - Split data into training and testing sets.
    - Train SVM, Random Forest, Logistic Regression, and Decision Tree models.
    - Evaluate model accuracy.
    - Visualize model comparison.

**Key Files for Model Training:**

- `Diabetes_Prediction.ipynb`: Jupyter notebook containing the entire ML pipeline.
- `diabetes.csv`: The dataset used for training.

After training your models, you will need to save the best-performing model to use it in your API.
Example:

```python
import pickle
# Assuming `classifier` is your best-trained model (e.g., SVM, Logistic Regression, or Random Forest)
filename = 'diabetes_model.pkl'
pickle.dump(classifier, open(filename, 'wb'))

# Also save the scaler
scaler_filename = 'scaler.pkl'
pickle.dump(scaler, open(scaler_filename, 'wb'))
```

---

## API Development (API তৈরি)

To make your trained model accessible to other applications (like the Flutter app), you'll create a RESTful API. We'll use Flask for this.

### Create a Flask Application (ফ্লাস্ক অ্যাপ্লিকেশন তৈরি)

1.  **Create a new file** named `app.py` (or `api.py`) in your project root.
2.  **Install Flask:**

    ```bash
    pip install flask gunicorn # gunicorn for production
    ```

3.  **`app.py` Example Code:**

    ```python
    import numpy as np
    import pandas as pd
    from flask import Flask, request, jsonify
    import pickle
    import os

    app = Flask(__name__)

    # Load the trained model and scaler
    # Make sure these files are in the same directory or provide full paths
    try:
        model_path = os.path.join(os.path.dirname(__file__), 'diabetes_model.pkl')
        scaler_path = os.path.join(os.path.dirname(__file__), 'scaler.pkl')

        model = pickle.load(open(model_path, 'rb'))
        scaler = pickle.load(open(scaler_path, 'rb'))
    except FileNotFoundError:
        print("Error: model.pkl or scaler.pkl not found. Please train and save them first.")
        model = None
        scaler = None

    @app.route('/')
    def home():
        return "Diabetes Prediction API is running!"

    @app.route('/predict', methods=['POST'])
    def predict():
        if model is None or scaler is None:
            return jsonify({'error': 'Model or scaler not loaded. Please ensure files exist.'}), 500

        data = request.get_json(force=True)

        # Expected input format:
        # {
        #   "Pregnancies": 6,
        #   "Glucose": 148,
        #   "BloodPressure": 72,
        #   "SkinThickness": 35,
        #   "Insulin": 0,
        #   "BMI": 33.6,
        #   "DiabetesPedigreeFunction": 0.627,
        #   "Age": 50
        # }

        # Convert input data to a DataFrame
        try:
            input_data = pd.DataFrame([data])

            # Standardize the input data using the loaded scaler
            standardized_input = scaler.transform(input_data)

            # Make prediction
            prediction = model.predict(standardized_input)

            output = 'diabetic' if prediction[0] == 1 else 'not diabetic'

            return jsonify({'prediction': output})
        except Exception as e:
            return jsonify({'error': str(e)}), 400

    if __name__ == '__main__':
        app.run(debug=True) # Set debug=False in production
    ```

4.  **Create `requirements.txt`:**
    ```bash
    pip freeze > requirements.txt
    ```
    This file lists all Python dependencies, which is crucial for deployment.

---

## Hosting on Render (Render এ হোস্টিং)

Render is a cloud platform that makes it easy to deploy web applications.

### Deployment Steps (ডিপ্লয়মেন্ট ধাপসমূহ)

1.  **Push your code to GitHub:**
    Make sure your `Diabetes_Prediction.ipynb`, `diabetes.csv`, `diabetes_model.pkl`, `scaler.pkl`, `app.py`, and `requirements.txt` files are pushed to your GitHub repository.

2.  **Create a new Web Service on Render:**

    - Go to [Render Dashboard](https://dashboard.render.com/).
    - Click "New Web Service".
    - Connect your GitHub account and select your `diabetes-prediction` repository.
    - **Configuration:**
      - **Name:** Choose a unique name for your service (e.g., `diabetes-predictor-api`).
      - **Region:** Select a region close to your users.
      - **Branch:** `main` (or your primary branch).
      - **Root Directory:** `/` (or your project's root directory if it's a subfolder).
      - **Runtime:** `Python 3`
      - **Build Command:** `pip install -r requirements.txt`
      - **Start Command:** `gunicorn app:app` (if your Flask app is in `app.py` and the Flask instance is named `app`)
      - **Environment Variables (Optional):** If you have any sensitive information, add them here.
      - **Scaling:** Choose a suitable instance type (e.g., Free for testing).

3.  **Deploy:** Click "Create Web Service". Render will automatically build and deploy your application. You'll get a public URL for your API (e.g., `https://diabetes-predictor-api.onrender.com`).

---

## Flutter Integration (ফ্লটার ইন্টিগ্রেশন)

Now, let's create a simple Flutter app to interact with your deployed API.

### Prerequisites (পূর্বশর্ত)

1.  **Flutter SDK** (installed and configured)
2.  **Android Studio / VS Code** with Flutter plugin

### Create a new Flutter Project (নতুন ফ্লটার প্রজেক্ট তৈরি)

```bash
flutter create diabetes_app
cd diabetes_app
```

### Update `pubspec.yaml`

Add the `http` package for making network requests:

```yaml
# ... other dependencies
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.1 # Add this line
  cupertino_icons: ^1.0.2
# ... rest of the file
```

Run `flutter pub get` after modifying `pubspec.yaml`.

### `main.dart` Example (সাধারণ `main.dart` কোড)

Replace the content of `lib/main.dart` with the following:

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diabetes Predictor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DiabetesPredictorScreen(),
    );
  }
}

class DiabetesPredictorScreen extends StatefulWidget {
  @override
  _DiabetesPredictorScreenState createState() => _DiabetesPredictorScreenState();
}

class _DiabetesPredictorScreenState extends State<DiabetesPredictorScreen> {
  final TextEditingController pregnanciesController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController bloodPressureController = TextEditingController();
  final TextEditingController skinThicknessController = TextEditingController();
  final TextEditingController insulinController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController dpfController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String predictionResult = '';
  final String apiUrl = 'YOUR_RENDER_API_URL/predict'; // Replace with your Render API URL

  Future<void> predictDiabetes() async {
    final Map<String, dynamic> data = {
      "Pregnancies": int.tryParse(pregnanciesController.text) ?? 0,
      "Glucose": int.tryParse(glucoseController.text) ?? 0,
      "BloodPressure": int.tryParse(bloodPressureController.text) ?? 0,
      "SkinThickness": int.tryParse(skinThicknessController.text) ?? 0,
      "Insulin": int.tryParse(insulinController.text) ?? 0,
      "BMI": double.tryParse(bmiController.text) ?? 0.0,
      "DiabetesPedigreeFunction": double.tryParse(dpfController.text) ?? 0.0,
      "Age": int.tryParse(ageController.text) ?? 0,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        setState(() {
          predictionResult = 'Prediction: ${result['prediction']}';
        });
      } else {
        setState(() {
          predictionResult = 'Error: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        predictionResult = 'Network Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diabetes Predictor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildInputField(pregnanciesController, 'Pregnancies', keyboardType: TextInputType.number),
            _buildInputField(glucoseController, 'Glucose', keyboardType: TextInputType.number),
            _buildInputField(bloodPressureController, 'Blood Pressure', keyboardType: TextInputType.number),
            _buildInputField(skinThicknessController, 'Skin Thickness', keyboardType: TextInputType.number),
            _buildInputField(insulinController, 'Insulin', keyboardType: TextInputType.number),
            _buildInputField(bmiController, 'BMI', keyboardType: TextInputType.numberWithOptions(decimal: true)),
            _buildInputField(dpfController, 'Diabetes Pedigree Function', keyboardType: TextInputType.numberWithOptions(decimal: true)),
            _buildInputField(ageController, 'Age', keyboardType: TextInputType.number),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: predictDiabetes,
              child: const Text('Predict Diabetes'),
            ),
            const SizedBox(height: 20),
            Text(
              predictionResult,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String labelText, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
```

**Important:** Replace `'YOUR_RENDER_API_URL/predict'` with the actual URL of your deployed Render API (e.g., `https://diabetes-predictor-api.onrender.com/predict`).

### Run the Flutter App (ফ্লটার অ্যাপ্লিকেশন চালানো)

Connect a mobile device or start an emulator/simulator, then run:

```bash
flutter run
```

---

## Usage (ব্যবহার)

### For the API:

Send a POST request to `YOUR_RENDER_API_URL/predict` with a JSON body containing the patient's data.

**Example Request (JSON):**

```json
{
  "Pregnancies": 1,
  "Glucose": 89,
  "BloodPressure": 66,
  "SkinThickness": 23,
  "Insulin": 94,
  "BMI": 28.1,
  "DiabetesPedigreeFunction": 0.167,
  "Age": 21
}
```

**Example Response (JSON):**

```json
{
  "prediction": "not diabetic"
}
```

### For the Flutter App:

- Open the app on your device/emulator.
- Enter the patient's diagnostic values in the respective fields.
- Tap the "Predict Diabetes" button.
- The prediction result will be displayed below the button.

---

## Future Improvements (ভবিষ্যতের উন্নতি)

- **Model Improvement:**
  - Experiment with more advanced machine learning models (e.g., XGBoost, LightGBM, Neural Networks).
  - Perform more extensive hyperparameter tuning using GridSearchCV or RandomizedSearchCV.
  - Implement cross-validation for more robust model evaluation.
  - Explore feature selection techniques to identify the most impactful features.
  - Address class imbalance if necessary (e.g., using SMOTE).
- **API Enhancements:**
  - Add input validation to the API for robustness.
  - Implement authentication/authorization for secure access.
  - Containerize the API using Docker.
- **Flutter App Enhancements:**
  - Improve UI/UX with better design and input validation.
  - Add loading indicators and error messages for better user feedback.
  - Implement local storage for predictions (if applicable).
  - Add user authentication.

---
