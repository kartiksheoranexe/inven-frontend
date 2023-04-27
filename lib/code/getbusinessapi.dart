import 'dart:convert';
import 'config.dart';
import 'package:http/http.dart' as http;
import 'loginapi.dart';

class Business {
  final String businessName;
  final String businessType;
  final String businessAddress;
  final String businessCity;
  final String businessState;
  final String businessCountry;
  final String businessPhone;

  Business({
    required this.businessName,
    required this.businessType,
    required this.businessAddress,
    required this.businessCity,
    required this.businessState,
    required this.businessCountry,
    required this.businessPhone,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      businessName: json['business_name'],
      businessType: json['business_type'],
      businessAddress: json['business_address'],
      businessCity: json['business_city'],
      businessState: json['business_state'],
      businessCountry: json['business_country'],
      businessPhone: json['business_phone'],
    );
  }
}

Future<List<Business>> getBusinessList() async {
  final url = Uri.parse('http://${AppConfig.host}:${AppConfig.port}/inventory/list_business/');
  String? authToken = await AuthStorage.getToken();

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Token $authToken',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    List<Business> businesses = data.map((item) => Business.fromJson(item)).toList();
    return businesses;
  } else {
    throw Exception('Failed to load business list');
  }
}
