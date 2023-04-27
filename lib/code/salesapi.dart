import 'dart:convert';
import 'package:inven/code/config.dart';
import 'package:inven/models/salesperformancemodel.dart';
import 'package:http/http.dart' as http;
import 'loginapi.dart';

Future<SalesPerformance> fetchSalesPerformance({required String businessName, required int timePeriod}) async {
  final url = Uri.parse('http://${AppConfig.host}:${AppConfig.port}/inventory/sales-performance/');
  String? authToken = await AuthStorage.getToken();
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Token $authToken',
  };

  final queryParams = {
    'business': businessName,
    'time_period': timePeriod.toString(),
  };

  final response = await http.get(url.replace(queryParameters: queryParams), headers: headers);
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return SalesPerformance.fromJson(jsonData);
  } else {
    throw Exception('Failed to load sales performance data');
  }
}
