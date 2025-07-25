import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl =
      'https://diabetes-prediction-api-zo7p.onrender.com';

  static Future<int> predictDiabetes(List<double> features) async {
    final url = Uri.parse('$_baseUrl/predict');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'features': features});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['prediction'];
    } else {
      throw Exception('Failed to load prediction: ${response.statusCode}');
    }
  }
}
