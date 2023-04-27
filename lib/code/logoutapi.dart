import 'dart:convert';
import 'config.dart';
import 'package:http/http.dart' as http;

class LogoutApi {
  static const String _baseUrl = 'http://${AppConfig.host}:${AppConfig.port}';
  static const String _logoutEndpoint = '$_baseUrl/inventory/logout-user/';

  static Future<void> logoutUser(String token) async {
    try {
      final response = await http.post(
        Uri.parse(_logoutEndpoint),
        headers: {
          'Authorization': 'Token $token',
        },
      );
      print(response.body);
      if (response.statusCode == 204) {
        print('Logout successful');
      } else {
        print('Logout failed: ${response.body}');
        throw Exception('Logout failed');
      }
    } catch (e) {
      print('Error logging out: $e');
      throw e;
    }
  }
}
