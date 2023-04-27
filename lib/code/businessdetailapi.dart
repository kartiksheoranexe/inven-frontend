import 'dart:convert';
import 'config.dart';
import 'loginapi.dart';
import 'package:http/http.dart' as http;
import 'package:inven/models/businessmodel.dart';


class BusinessApi {
  static Future<List<Business>> fetchBusinesses() async {
    final url = Uri.parse('http://${AppConfig.host}:${AppConfig.port}/inventory/list_business/');
    String? authToken = await AuthStorage.getToken();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $authToken',
    };

    final response = await http.get(url, headers: headers);
    print(response.body);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((business) => Business.fromJson(business)).toList();
    } else {
      throw Exception('Failed to load businesses');
    }
  }
}
