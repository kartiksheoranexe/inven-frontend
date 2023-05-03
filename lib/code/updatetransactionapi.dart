import 'dart:convert';
import 'loginapi.dart';
import 'config.dart';
import 'package:http/http.dart' as http;

Future<http.Response> updateTransactionStatus({
  required List<String> transactionIds,
  required String identifier,
}) async {
  final url = Uri.parse('http://${AppConfig.host}:${AppConfig.port}/inventory/update-transaction-status/');
  String? authToken = await AuthStorage.getToken();

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Token $authToken',
  };

  final body = jsonEncode({
    'transaction_ids': transactionIds,
    'identifier': identifier,
  });

  final response = await http.patch(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Failed to update transaction status!');
  }
}
