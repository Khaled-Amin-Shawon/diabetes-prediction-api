# Diabetes Prediction Flutter App

## Overview

This is a Flutter mobile application designed to predict the risk of diabetes based on various health metrics provided by the user. The app utilizes a deployed REST API to perform the prediction, providing a clean and interactive user experience.

## Features

- **Diabetes Prediction:** Takes 8 health metrics as input and predicts whether a person is diabetic or not using an external REST API.
- **Intuitive UI/UX:**
  - **Splash Screen:** A visually appealing splash screen on app launch.
  - **Animated Intro Screen:** An interactive introduction screen with smooth animations and a 'Get Started' button.
  - **Enhanced Input Fields:** Modern and user-friendly `TextFormField` inputs with icons and improved styling.
  - **Clear Prediction Result:** Displays the prediction result ('Diabetic' or 'Not Diabetic') on a dedicated screen with smooth animations and clear visual indicators (red for Diabetic, green for Not Diabetic).
- **REST API Integration:** Communicates with a live REST API for real-time predictions.
- **Loading Indicator:** Shows a loading indicator during API calls for better user feedback.
- **Error Handling:** Basic error handling for API call failures.
- **Modular Architecture:** Codebase organized into `services` and `screens` for better maintainability and scalability.

## API Information

- **Base URL:** `https://diabetes-prediction-api-zo7p.onrender.com`
- **POST Endpoint:** `/predict`
- **Request Body (JSON):**
  ```json
  {
    "features": [pregnancies, glucose, bloodPressure, skinThickness, insulin, bmi, diabetesPedigree, age]
  }
  ```
- **Response (JSON):**
  ```json
  {
    "prediction": 0 // or 1
  }
  ```

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine.

### Prerequisites

- Flutter SDK installed ([Installation Guide](https://docs.flutter.dev/get-started/install))
- A code editor (e.g., VS Code with Flutter extension, Android Studio)

### Installation

1.  **Clone the repository:**
    ```bash
    git clone <repository_url>
    cd diabetes_prediction
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

### Running the App

1.  **Ensure Android Internet Permission:**
    Make sure the following line is present in your `android/app/src/main/AndroidManifest.xml` file, inside the `<manifest>` tag, above the `<application>` tag:
    ```xml
    <uses-permission android:name="android.permission.INTERNET" />
    ```
2.  **Run on a device or emulator:**
    ```bash
    flutter run
    ```
    Or, open the project in your IDE and run it.

## Project Structure

- `lib/main.dart`: Entry point of the Flutter application, setting up the initial screen.
- `lib/screens/`: Contains all the UI screens of the application.
  - `splash_screen.dart`: The initial splash screen displayed on app launch.
  - `animated_intro_screen.dart`: An introductory screen with animations and a 'Get Started' button.
  - `diabetes_prediction_screen.dart`: The main screen for user input and triggering predictions.
  - `prediction_result_screen.dart`: Displays the prediction outcome with animations.
- `lib/services/`: Contains service classes for API interactions.
  - `api_service.dart`: Handles all communications with the diabetes prediction REST API.

## Dependencies

The project uses the following key dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  cupertino_icons: ^1.0.8
```

## Contributing

Feel free to fork the repository, create a branch, and contribute to this project. Pull requests are welcome.

## License

This project is licensed under the MIT License - see the `LICENSE` file for details. (Note: A `LICENSE` file is not included in this example; it's a placeholder for standard practice.)

## Contact

If you have any questions or suggestions, feel free to open an issue or contact the maintainer.
