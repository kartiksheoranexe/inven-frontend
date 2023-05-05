import 'dart:convert';
import 'config.dart';
import 'package:http/http.dart' as http;

Future<http.Response> requestPasswordReset(String identifier) async {
  final url = 'http://${AppConfig.host}:${AppConfig.port}/inventory/password-reset-request/';
  final body = jsonEncode({"identifier": identifier});

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  );

  return response;
}
