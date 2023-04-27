import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'package:inven/models/transactionmodel.dart';
import 'package:inven/code/loginapi.dart';

Future<List<Transaction>>  getTransactionDetails(String date, String selectedBusinessName) async {
  final String url = 'http://${AppConfig.host}:${AppConfig.port}/inventory/transaction-details/';
  String? authToken = await AuthStorage.getToken();

  final Map<String, String> queryParams = {
    'date': date,
    'business_name': selectedBusinessName,
  };
  final Uri uri = Uri.parse(url).replace(queryParameters: queryParams);
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Token $authToken',
  };

  final http.Response response = await http.get(uri, headers: headers);

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((transaction) => Transaction.fromJson(transaction)).toList();
  } else {
    throw Exception('Failed to load transaction details');
  }
}
