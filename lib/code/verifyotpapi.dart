import 'dart:convert';
import 'config.dart';
import 'package:http/http.dart' as http;

Future<bool> verifyOtp({
  required String identifier,
  required String otp,
}) async {
  final url = 'http://${AppConfig.host}:${AppConfig.port}/inventory/verify-otp/';

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'identifier': identifier,
      'otp': otp,
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
