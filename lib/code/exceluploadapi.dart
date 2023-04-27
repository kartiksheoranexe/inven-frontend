import 'dart:convert';
import 'dart:io';
import 'config.dart';
import 'package:http/http.dart' as http;
import 'loginapi.dart';

Future<Map<String, dynamic>> importItemExcel(File file) async {
  final url = 'http://${AppConfig.host}:${AppConfig.port}/inventory/import-item-excel/';
  String? authToken = await AuthStorage.getToken();

  try {
    // Create a multipart request
    final request = http.MultipartRequest('POST', Uri.parse(url));

    // Set the headers
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Token $authToken',
    });

    // Attach the file
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    // Send the request
    final response = await request.send();

    // Check if the status is success
    if (response.statusCode == 201) {
      // Decode the JSON response
      final jsonResponse = jsonDecode(await response.stream.bytesToString());

      return {
        'status': 'success',
        'message': jsonResponse['message'],
        'added_rows': jsonResponse['added_rows'],
        'updated_rows': jsonResponse['updated_rows'],
      };
    } else {
      return {
        'status': 'error',
        'message': 'An error occurred while importing data.',
      };
    }
  } catch (e) {
    return {
      'status': 'error',
      'message': 'An exception occurred: $e',
    };
  }
}
