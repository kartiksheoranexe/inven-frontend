import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:inven/code/loginapi.dart';

Future<void> deleteUpiDetails(String upi) async {
  final url = 'http://${AppConfig.host}:${AppConfig.port}/inventory/del_upi_details/';
  String? authToken = await AuthStorage.getToken();

  final response = await http.delete(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Token $authToken',
    },
    body: jsonEncode({
      'upi': upi,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to delete UPI details');
  }
}
