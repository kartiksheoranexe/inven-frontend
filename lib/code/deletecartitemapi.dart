import 'dart:convert';
import 'loginapi.dart';
import 'config.dart';
import 'package:http/http.dart' as http;

Future<void> deleteCartItem(int cartItemId) async {
  final url = Uri.parse('http://${AppConfig.host}:${AppConfig.port}/inventory/cart/$cartItemId/');
  String? authToken = await AuthStorage.getToken();
  final response = await http.delete(
    url,
    headers: {
      'Authorization': 'Token $authToken',
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode != 204) {
    final responseBody = json.decode(response.body);
    final errorMessage = responseBody['detail'] ?? 'Something went wrong.';
    throw Exception(errorMessage);
  }
}
