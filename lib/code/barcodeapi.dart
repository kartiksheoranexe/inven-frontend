import 'dart:convert';
import 'config.dart';
import 'loginapi.dart';
import 'package:http/http.dart' as http;


Future<http.Response> generateQrCode(
    {
      required int quantityDelta,
      required double price
    }
    ) async {
  final url = Uri.parse("http://${AppConfig.host}:${AppConfig.port}/inventory/generate-qr-code/");
  String? authToken = await AuthStorage.getToken();

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Token $authToken',
  };

  final body = jsonEncode({
    "quantity_delta": quantityDelta,
    "price": price
  });

  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Failed to load qrcode!');
  }

}
