import 'package:inven/code/loginapi.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

Future<http.Response> updateItemQuantity({
  required String business,
  required String distributorsName,
  required String category,
  required String itemName,
  required String itemType,
  required int size,
  required String uom,
  required int quantityDelta,
  required Map<String, dynamic> additionalInfo,
}) async {
  final Uri url = Uri.parse('http://${AppConfig.host}:${AppConfig.port}/inventory/modify-item-quantity/');
  String? authToken = await AuthStorage.getToken();

  // Assign the request body to a variable
  String requestBody = jsonEncode({
    "business": business,
    "distributors_name": distributorsName,
    "category": category,
    "item_name": itemName,
    "item_type": itemType,
    "size": size,
    "uom": uom,
    "quantity_delta": quantityDelta,
    "additional_info": additionalInfo,
  });
  print(requestBody);

  final response = await http.patch(
    url,
    body: requestBody, // Use the requestBody variable as the body of the request
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Token $authToken',
    },
  );

  return response;
}
