import 'dart:convert';
import 'config.dart';
import 'loginapi.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> createSupplier(String business, String category, String distributorName) async {
  const String url = 'http://${AppConfig.host}:${AppConfig.port}/inventory/create_supplier/';
  String? authToken = await AuthStorage.getToken();

  final response = await http.post(
    Uri.parse(url),
    body: jsonEncode({
      "business": business,
      "category": category,
      "distributor_name": distributorName,
    }),
    headers: {
      "Content-Type": "application/json",
      'Authorization': 'Token $authToken'
    },
  );

  return {
    'statusCode': response.statusCode,
    'body': jsonDecode(response.body),
  };
}
