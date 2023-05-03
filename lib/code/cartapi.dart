import 'dart:convert';
import 'config.dart';
import 'loginapi.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> addItemToCart({required int itemId, required int quantity}) async {
  final String url = "http://${AppConfig.host}:${AppConfig.port}/inventory/cart/";
  String? authToken = await AuthStorage.getToken();
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Token $authToken',
  };

  final body = jsonEncode({
    'item_id': itemId,
    'quantity': quantity,
  });
  // print(body);
  final response = await http.post(Uri.parse(url), headers: headers, body: body);
  if (response.statusCode == 201) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to add item to cart');
  }
}
