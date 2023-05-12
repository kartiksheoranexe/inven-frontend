import 'dart:convert';
import 'config.dart';
import 'loginapi.dart';
import 'package:http/http.dart' as http;
import 'package:inven/models/inventorymodel.dart';

class InventoryApi {
  static Future<List<Item>> searchItems({
    required String businessName,
    required String category,
    required String distributorName,
    required dynamic itemName,
  }) async {
    final url = Uri.parse('http://${AppConfig.host}:${AppConfig.port}/inventory/search-items/');

    String? authToken = await AuthStorage.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $authToken',
    };

    final queryParams = {
      'business_name': businessName,
      'category': category,
      'distributor_name': distributorName,
      'item_name': itemName,
    };
    print(queryParams);
    final response = await http.get(url.replace(queryParameters: queryParams), headers: headers);
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      final items = jsonData.map((json) => Item.fromJson(json)).toList();
      return items;
    } else {
      throw Exception('Item not found');
    }
  }
}
