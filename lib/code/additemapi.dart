import 'dart:convert';
import 'config.dart';
import 'package:inven/code/loginapi.dart';
import 'package:http/http.dart' as http;

Future<bool> addItem({
  required String businessName,
  required String category,
  required String distributorName,
  required String itemName,
  required String size,
  required String unitOfMeasurement,
  required int quantity,
  required double price,
  required int alertquantity,
  Map<String, dynamic>? additionalInfo,
}) async {
  final url = Uri.parse("http://${AppConfig.host}:${AppConfig.port}/inventory/add-item/");
  String? authToken = await AuthStorage.getToken();

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Token $authToken',
  };

  final body = jsonEncode({
    'business_name': businessName,
    'category': category,
    'distributor_name': distributorName,
    'item_name': itemName,
    'item_type':'Medicine',
    'size': size,
    'unit_of_measurement': unitOfMeasurement,
    'quantity': quantity,
    'price': price,
    'alert_quantity': alertquantity,
    if (additionalInfo != null) 'additional_info': additionalInfo,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}
