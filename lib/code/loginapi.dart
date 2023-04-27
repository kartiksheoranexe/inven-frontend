import 'dart:convert';
import 'config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ResponseReceiverlogin {
  void receive(Map<String, dynamic>? data) {
    if (data != null) {
      // Do something with the response data here, if needed
    } else {
      print('Wrong Username or Password');
    }
  }
}

class AuthStorage {
  static const _authTokenKey = 'token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
  }

  static const _usernameKey = 'username';

  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

}

Future<String?> login({
  required String username,
  required String password,
  required ResponseReceiverlogin responseReceiver,
}) async {
  final url = Uri.parse('http://${AppConfig.host}:${AppConfig.port}/inventory/login-user/');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    'username': username,
    'password': password,
  });
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = json.decode(response.body);
    String? authToken = responseData['token'];
    await AuthStorage.saveToken(authToken!);
    await AuthStorage.saveUsername(username);
    responseReceiver.receive(responseData);
    print(authToken);
    return authToken;
  } else {
    String responseError = response.body;
    responseReceiver.receive(null);
    return null;
  }
}

