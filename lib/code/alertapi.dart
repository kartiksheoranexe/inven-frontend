import 'dart:convert';
import 'config.dart';
import 'loginapi.dart';
import 'package:http/http.dart' as http;
import 'package:inven/models/alertmodel.dart';

class AlertApi {
  static Future<List<Alert>> alertMedicines({required String businessName}) async {
    final url = Uri.parse('http://${AppConfig.host}:${AppConfig.port}/inventory/raise-alert/');
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
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      final medicines = jsonData.map((json) => Alert.fromJson(json)).toList();
      return medicines;
    } else {
      throw Exception('Failed to load medicines');
    }
  }
}
