import 'dart:convert';
import 'config.dart';
import 'package:http/http.dart' as http;

Future<http.Response> resetPassword({
  required String email,
  required String otp,
  required String newPassword,
}) async {
  final url = 'http://${AppConfig.host}:${AppConfig.port}/inventory/password-reset/';

  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'identifier': email,
      'otp': otp,
      'new_password': newPassword,
    }),
  );

  return response;
}
