import 'dart:convert';
import 'config.dart';
import 'package:http/http.dart' as http;
import 'loginapi.dart';

Future<http.Response> registerUpi({
  required String payeeVpa,
  required String payeeName,
  required String merchantCode,
  required String url,
}) async {
  final apiEndpoint = Uri.parse("http://${AppConfig.host}:${AppConfig.port}/inventory/register-your-upi/");
  String? authToken = await AuthStorage.getToken();

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Token $authToken',
  };

  final body = jsonEncode({
    "payee_vpa": payeeVpa,
    "payee_name": payeeName,
    "merchant_code": merchantCode,
    "url": url,
  });

  final response = await http.post(apiEndpoint, headers: headers, body: body);

  if (response.statusCode == 201) {
    return response;
  } else if (response.statusCode == 400) {
    return  http.Response('UPI details for this user already exist', 400);
  }
  else {
    throw Exception('Failed');
  }
}
