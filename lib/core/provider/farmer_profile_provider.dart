import 'dart:convert';
import 'dart:io';

import 'package:farmdirect/services/api_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:farmdirect/config/api_config.dart';

class ProfileProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  // ============================================================
  // LOCAL PROFILE IMAGE
  // ============================================================

  File? _profileImage;
  String _profileImageUrl = '';

  File? get profileImage => _profileImage;

  String get profileImageUrl => _profileImageUrl;

  String get fullProfileImageUrl {
    if (_profileImageUrl.isEmpty) return '';

    return '${ApiConfig.baseUrl}$_profileImageUrl';
  }

  String get defaultImage => 'assets/images/profile.png';

  // ============================================================
  // FARMER DATA
  // ============================================================

  String _name = '';
  String _email = '';
  String _phone = '';
  String _farmName = '';
  String _location = '';
  String _aadhaar = '';
  String _description = '';
  String _farmId = '';

  List<String> _crops = [];

  int? _userId;
  bool _isLoading = false;

  // ============================================================
  // GETTERS
  // ============================================================

  String get name => _name;

  String get email => _email;

  String get phone => _phone;

  String get farmName => _farmName;

  String get location => _location;

  String get aadhaar => _aadhaar;

  String get farmId => _farmId;
  String get description => _description;
  List<String> get crops => List.unmodifiable(_crops);

  int? get userId => _userId;

  bool get isLoading => _isLoading;

  // ============================================================
  // LOAD PROFILE FROM DATABASE
  // ============================================================
  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      // ============================================================
      // GET CURRENT FIREBASE USER
      // ============================================================

      final User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        debugPrint('No Firebase user currently logged in.');

        return;
      }

      debugPrint(
        'Loading profile for Firebase UID: '
        '${firebaseUser.uid}',
      );

      // ============================================================
      // GET USERS FROM FASTAPI
      // ============================================================

      final usersResponse = await http
          .get(Uri.parse('${ApiConfig.baseUrl}/users/'))
          .timeout(const Duration(seconds: 10));

      debugPrint(
        'Users API status: '
        '${usersResponse.statusCode}',
      );

      if (usersResponse.statusCode != 200) {
        throw Exception('Failed to load user information');
      }

      final List<dynamic> users = jsonDecode(usersResponse.body);

      debugPrint('🔥 TOTAL USERS = ${users.length}');

      for (final item in users) {
        if (item is Map<String, dynamic>) {
          debugPrint(
            '🔥 DB USER => '
            'id=${item['user_id']}, '
            'name=${item['name']}, '
            'firebase_uid=${item['firebase_uid']}',
          );
        }
      }

      // ============================================================
      // FIND CURRENT USER
      // ============================================================

      Map<String, dynamic>? currentUser;

      for (final item in users) {
        if (item is Map<String, dynamic> &&
            item['firebase_uid'] == firebaseUser.uid) {
          currentUser = item;
          break;
        }
      }

      if (currentUser == null) {
        throw Exception('User not found in PostgreSQL');
      }

      // ============================================================
      // LOAD USER DATA
      // ============================================================

      _userId = int.parse(currentUser['user_id'].toString());

      _name = currentUser['name']?.toString() ?? '';

      _email = currentUser['email']?.toString() ?? '';

      _phone = currentUser['phone']?.toString() ?? '';

      _profileImageUrl = currentUser['profile_image_url']?.toString() ?? '';

      debugPrint('PostgreSQL user_id: $_userId');

      debugPrint('Farmer name: $_name');

      debugPrint('Farmer email: $_email');
      debugPrint('Farmer name: $_name');

      debugPrint('Farmer phone: $_phone');

      debugPrint(
        'Farmer profile image URL: '
        '$_profileImageUrl',
      );

      // ============================================================
      // GET FARMER PROFILE
      // ============================================================

      final profileResponse = await http
          .get(Uri.parse('${ApiConfig.baseUrl}/farmer-profile/$_userId'))
          .timeout(const Duration(seconds: 10));

      debugPrint(
        'Farmer profile status: '
        '${profileResponse.statusCode}',
      );

      debugPrint(
        'Farmer profile response: '
        '${profileResponse.body}',
      );

      // ============================================================
      // FARMER PROFILE FOUND
      // ============================================================

      if (profileResponse.statusCode == 200) {
        final Map<String, dynamic> profile = jsonDecode(profileResponse.body);

        // ----------------------------------------------------------
        // FARMER ID
        // ----------------------------------------------------------

        _farmId = profile['farmer_id']?.toString() ?? '';

        // ----------------------------------------------------------
        // FARM DATA
        // ----------------------------------------------------------

        _farmName = profile['farm_name']?.toString() ?? '';

        _location = profile['farm_location']?.toString() ?? '';

        _aadhaar = profile['aadhaar']?.toString() ?? '';

        _description = profile['description']?.toString() ?? '';

        // ----------------------------------------------------------
        // CROPS
        // ----------------------------------------------------------

        final dynamic cropsData = profile['crops'];

        if (cropsData is List) {
          _crops = cropsData.map((crop) => crop.toString()).toList();
        } else {
          _crops = [];
        }

        // ----------------------------------------------------------
        // DEBUG
        // ----------------------------------------------------------

        debugPrint('Farmer ID: $_farmId');

        debugPrint('Farm name: $_farmName');

        debugPrint('Farm location: $_location');

        debugPrint('Aadhaar: $_aadhaar');

        debugPrint('Description: $_description');

        debugPrint('Crops: $_crops');

        debugPrint('Farmer profile loaded successfully.');
      }
      // ============================================================
      // FARMER PROFILE NOT FOUND
      // ============================================================
      else if (profileResponse.statusCode == 404) {
        debugPrint('Farmer profile does not exist.');

        _farmId = '';
        _farmName = '';
        _location = '';
        _aadhaar = '';
        _description = '';
        _crops = [];
      }
      // ============================================================
      // OTHER ERROR
      // ============================================================
      else {
        throw Exception('Failed to load Farmer profile');
      }
    } catch (e) {
      debugPrint('Profile loading error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // PICK PROFILE IMAGE
  // ============================================================

  Future<void> pickProfileImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    if (_userId == null) {
      debugPrint('Cannot upload image: user ID is null');

      return;
    }

    // ----------------------------------------------------------
    // SHOW SELECTED IMAGE IMMEDIATELY
    // ----------------------------------------------------------

    _profileImage = File(image.path);

    notifyListeners();

    try {
      debugPrint(
        'Uploading farmer profile image '
        'for user: $_userId',
      );

      final updatedUser = await ApiService.uploadProfileImage(
        userId: _userId!,
        imagePath: image.path,
      );

      _profileImageUrl = updatedUser['profile_image_url']?.toString() ?? '';

      debugPrint(
        'Farmer profile image uploaded: '
        '$_profileImageUrl',
      );

      debugPrint(
        'Full image URL: '
        '$fullProfileImageUrl',
      );

      // --------------------------------------------------------
      // SAVE BACKEND URL LOCALLY
      // --------------------------------------------------------

      final prefs = await SharedPreferences.getInstance();

      if (_profileImageUrl.isNotEmpty) {
        await prefs.setString('profile_image_url', _profileImageUrl);
      }

      notifyListeners();
    } catch (e) {
      debugPrint(
        'Farmer profile image upload error: '
        '$e',
      );
    }
  }

  // ============================================================
  // UPDATE NAME LOCALLY
  // ============================================================
  Future<bool> updateProfile({
    required String name,
    required String phone,
    required String email,
    required String bio,
  }) async {
    if (_userId == null) {
      debugPrint('Cannot update profile: user ID is null');
      return false;
    }

    final trimmedName = name.trim();
    final trimmedPhone = phone.trim();
    final trimmedEmail = email.trim();
    final trimmedBio = bio.trim();

    if (trimmedName.isEmpty) {
      debugPrint('Name cannot be empty');
      return false;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final response = await http
          .put(
            Uri.parse('${ApiConfig.baseUrl}/users/$_userId/profile'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': trimmedName,
              'email': trimmedEmail,
              'phone': trimmedPhone,
              'bio': trimmedBio,
            }),
          )
          .timeout(const Duration(seconds: 10));

      debugPrint('Update profile status: ${response.statusCode}');

      debugPrint('Update profile response: ${response.body}');

      if (response.statusCode != 200) {
        debugPrint('Profile update failed: ${response.body}');

        return false;
      }

      // --------------------------------------------------------
      // UPDATE PROVIDER IMMEDIATELY
      // --------------------------------------------------------
      _name = trimmedName;
      _phone = trimmedPhone;
      _email = trimmedEmail;
      _description = trimmedBio;
      // --------------------------------------------------------
      // RELOAD FROM DATABASE
      // --------------------------------------------------------

      await loadProfile();

      return true;
    } catch (e) {
      debugPrint('Profile update error: $e');

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
