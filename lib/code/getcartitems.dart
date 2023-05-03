import 'dart:convert';
import 'config.dart';
import 'loginapi.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> getCartItems() async {
  final String url = "http://${AppConfig.host}:${AppConfig.port}/inventory/cart/";
  String? authToken = await AuthStorage.getToken();
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Token $authToken',
  };

  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to get cart items');
  }
}
