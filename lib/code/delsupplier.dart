import 'dart:convert';
import 'config.dart';
import 'loginapi.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> deleteSupplier(String business, String category, String? distributor) async {
  final url = Uri.parse('http://${AppConfig.host}:${AppConfig.port}/inventory/del_suppliers/');
  String? authToken = await AuthStorage.getToken();

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Token $authToken',
  };

  Map<String, dynamic> requestBody = {
    'business': business,
    'category': category,
  };

  if (distributor != null && distributor.isNotEmpty) {
    requestBody['distributor_name'] = distributor;
  }

  final body = jsonEncode(requestBody);
  final response = await http.delete(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    return {'statusCode': 200, 'body': jsonDecode(response.body)};
  } else {
    return {'statusCode': response.statusCode, 'body': jsonDecode(response.body)};
  }
}
