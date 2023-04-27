import 'dart:convert';
import 'config.dart';
import 'loginapi.dart';
import 'package:http/http.dart' as http;

class AlertCountApi {
  static Future<String> alertMedicines({required String businessName}) async {
    final url = Uri.parse('http://${AppConfig.host}:${AppConfig.port}/inventory/alert-count/');
    String? authToken = await AuthStorage.getToken();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $authToken',
    };
    final body = jsonEncode({
      'business_name': businessName,
    });
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final jsonData = response.body;
      return jsonData;
    } else {
      throw Exception('Failed to load medicines');
    }
  }
}
