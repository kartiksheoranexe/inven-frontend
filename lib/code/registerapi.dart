import 'dart:convert';
import 'config.dart';
import 'package:http/http.dart' as http;

Future<bool> registerUser({
  required String username,
  required String email,
  required String password,
  required String dob,
  required String gender,
  required String phoneNo,
}) async {
  final String url = 'http://${AppConfig.host}:${AppConfig.port}/inventory/register-user/';
  final Map<String, String> headers = {'Content-Type': 'application/json'};
  final Map<String, String> requestBody = {
    'username': username,
    'email': email,
    'password': password,
    'dob': dob,
    'gender': gender,
    'phone_no': phoneNo,
  };

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 201) {
    return true;
  } else {
    print('Error: ${response.body}');
    return false;
  }
}
