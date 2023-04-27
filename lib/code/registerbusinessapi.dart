import 'dart:convert';
import 'config.dart';
import 'package:http/http.dart' as http;

class BusinessRegistration {
  final String businessName;
  final String businessType;
  final String businessAddress;
  final String businessCity;
  final String businessState;
  final String businessCountry;
  final String businessPhone;
  final String businessEmail;

  BusinessRegistration({
    required this.businessName,
    required this.businessType,
    required this.businessAddress,
    required this.businessCity,
    required this.businessState,
    required this.businessCountry,
    required this.businessPhone,
    required this.businessEmail,
  });
}

Future<Map<String, dynamic>?> registerBusiness(BusinessRegistration registrationData, String authToken) async {
  final url = Uri.parse('http://${AppConfig.host}:${AppConfig.port}/inventory/register_business/');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Token $authToken',
  };
  final body = jsonEncode({
    'business_name': registrationData.businessName,
    'business_type': registrationData.businessType,
    'business_address': registrationData.businessAddress,
    'business_city': registrationData.businessCity,
    'business_state': registrationData.businessState,
    'business_country': registrationData.businessCountry,
    'business_phone': registrationData.businessPhone,
    'business_email': registrationData.businessEmail,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    return json.decode(response.body);
  } else {
    print('Error registering business: ${response.statusCode}');
    print(response.body);
    return null;
  }
    }
