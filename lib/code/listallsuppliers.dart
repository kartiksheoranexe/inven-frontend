import 'dart:convert';
import 'loginapi.dart';
import 'config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getAllSuppliers(String business) async {
  final url = Uri.parse('http://${AppConfig.host}:${AppConfig.port}/inventory/all_suppliers/?business=' + Uri.encodeComponent(business));
  String? authToken = await AuthStorage.getToken();

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Token $authToken',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final Map<String, String> supplierMap = {};

    for (final supplier in data) {
      final category = supplier['category'];
      final distributorName = supplier['distributor_name'];

      supplierMap[category] = distributorName;
    }

    print(supplierMap);

    return {'statusCode': 200, 'suppliers': supplierMap};
  } else {
    return {'statusCode': response.statusCode};
  }
}
