import 'dart:convert';
import 'package:farmdirect/config/api_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // ============================================================
  // CREATE USER - REGISTRATION
  // ============================================================

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

    throw Exception('Server error: ${response.statusCode}');
  }

  // ============================================================
  // GET USER BY FIREBASE UID
  // ============================================================

  static Future<Map<String, dynamic>> getUserByFirebaseUid({
    required String firebaseUid,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/users/by-firebase/$firebaseUid'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    if (response.statusCode == 404) {
      final body = jsonDecode(response.body);

      throw Exception(body['detail'] ?? 'User not found');
    }

    throw Exception('Server error: ${response.statusCode}');
  }

  // ===================================
  // UPDATE USER
  // =====================================
  static Future<Map<String, dynamic>> updateUser({
    required int userId,
    required String name,
    required String email,
    required String phone,
  }) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'name': name, 'email': email, 'phone': phone}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Failed to update user: ${response.body}');
  }

  // ============================================================
  // UPLOAD PROFILE IMAGE
  // ============================================================

  static Future<Map<String, dynamic>> uploadProfileImage({
    required int userId,
    required String imagePath,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/users/$userId/profile-image'),
    );

    request.headers['Accept'] = 'application/json';

    request.files.add(await http.MultipartFile.fromPath('file', imagePath));

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    debugPrint('UPLOAD STATUS: ${response.statusCode}');
    debugPrint('UPLOAD RESPONSE: ${response.body}');

    throw Exception('Failed to upload profile image: ${response.body}');
  }
}
