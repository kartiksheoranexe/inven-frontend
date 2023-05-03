import 'dart:convert';
import 'config.dart';
import 'package:inven/code/loginapi.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> getUpiDetails() async {
  final String url = 'http://${AppConfig.host}:${AppConfig.port}/inventory/list_upi_details/';
  String? authToken = await AuthStorage.getToken();

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Token $authToken',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load UPI details');
  }
}
