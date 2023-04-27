import 'dart:convert';
import 'config.dart';
import 'loginapi.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchTopItems({required String businessName}) async {
  final Uri url = Uri.http('${AppConfig.host}:${AppConfig.port}', '/inventory/top-items/', {
    'business': businessName
  });

  String? authToken = await AuthStorage.getToken();
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Token $authToken',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load top items');
  }
}
