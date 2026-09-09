import 'dart:convert';
import 'package:farmdirect/config/api_config.dart';
import 'package:http/http.dart' as http;

class ApiService {

  static Future<Map<String, dynamic>> createUser({
    required String firebaseUid,
    required String name,
    required String email,
    required String phone,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/users/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'firebase_uid': firebaseUid,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    if (response.statusCode == 400) {
      final body = jsonDecode(response.body);
      throw Exception(body['detail'] ?? 'User creation failed');
    }

    throw Exception(
      'Server error: ${response.statusCode}',
    );
  }
}