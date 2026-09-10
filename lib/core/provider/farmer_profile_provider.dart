import 'dart:convert';
import 'dart:io';

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

  File? get profileImage => _profileImage;

  String get defaultImage =>
      'assets/images/profile.png';

  // ============================================================
  // FARMER DATA
  // ============================================================

  String _name = '';
  String _email = '';
  String _phone = '';
  String _farmName = '';
  String _location = '';
  String _aadhaar = '';
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

  List<String> get crops => List.unmodifiable(_crops);

  int? get userId => _userId;

  bool get isLoading => _isLoading;

  // ============================================================
  // LOAD PROFILE
  // ============================================================

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      // --------------------------------------------------------
      // Firebase current user
      // --------------------------------------------------------

      final User? firebaseUser =
          FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        debugPrint(
          'No Firebase user currently logged in.',
        );

        return;
      }

      debugPrint(
        'Loading profile for Firebase UID: '
        '${firebaseUser.uid}',
      );

      // --------------------------------------------------------
      // GET USERS FROM FASTAPI
      // --------------------------------------------------------

      final usersResponse = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/users/',
        ),
      ).timeout(
        const Duration(seconds: 10),
      );

      debugPrint(
        'Users API status: '
        '${usersResponse.statusCode}',
      );

      if (usersResponse.statusCode != 200) {
        throw Exception(
          'Failed to load user information',
        );
      }

      final List<dynamic> users =
          jsonDecode(usersResponse.body);

      // --------------------------------------------------------
      // FIND CURRENT USER
      // --------------------------------------------------------

      Map<String, dynamic>? currentUser;

      for (final item in users) {
        if (item is Map<String, dynamic> &&
            item['firebase_uid'] ==
                firebaseUser.uid) {
          currentUser = item;
          break;
        }
      }

      if (currentUser == null) {
        throw Exception(
          'User not found in PostgreSQL',
        );
      }

      // --------------------------------------------------------
      // USER DATA
      // --------------------------------------------------------

      _userId = int.parse(
        currentUser['user_id'].toString(),
      );

      _name =
          currentUser['name']?.toString() ?? '';

      _email =
          currentUser['email']?.toString() ?? '';

      _phone =
          currentUser['phone']?.toString() ?? '';

      debugPrint(
        'PostgreSQL user_id: $_userId',
      );

      debugPrint(
        'Farmer name: $_name',
      );

      // --------------------------------------------------------
      // GET FARMER PROFILE
      // --------------------------------------------------------

      final profileResponse = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/farmer-profile/$_userId',
        ),
      ).timeout(
        const Duration(seconds: 10),
      );

      debugPrint(
        'Farmer profile status: '
        '${profileResponse.statusCode}',
      );

      debugPrint(
        'Farmer profile response: '
        '${profileResponse.body}',
      );

      if (profileResponse.statusCode == 200) {
        final Map<String, dynamic> profile =
            jsonDecode(profileResponse.body);

        _farmName =
            profile['farm_name']?.toString() ?? '';

        _location =
            profile['farm_location']?.toString() ?? '';

        _aadhaar =
            profile['aadhaar']?.toString() ?? '';

        final dynamic cropsData =
            profile['crops'];

        if (cropsData is List) {
          _crops = cropsData
              .map((crop) => crop.toString())
              .toList();
        }

        debugPrint(
          'Farmer profile loaded successfully.',
        );
      } else if (profileResponse.statusCode == 404) {
        debugPrint(
          'Farmer profile does not exist.',
        );

        _farmName = '';
        _location = '';
        _aadhaar = '';
        _crops = [];
      } else {
        throw Exception(
          'Failed to load Farmer profile',
        );
      }

      // --------------------------------------------------------
      // LOAD LOCAL PROFILE IMAGE
      // --------------------------------------------------------

      await _loadLocalProfileImage();
    } catch (e) {
      debugPrint(
        'Profile loading error: $e',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // LOAD LOCAL PROFILE IMAGE
  // ============================================================

  Future<void> _loadLocalProfileImage() async {
    final prefs =
        await SharedPreferences.getInstance();

    final imagePath =
        prefs.getString('profile_image');

    if (imagePath != null &&
        imagePath.isNotEmpty) {
      final file = File(imagePath);

      if (await file.exists()) {
        _profileImage = file;
      }
    }
  }

  // ============================================================
  // PICK PROFILE IMAGE
  // ============================================================

  Future<void> pickProfileImage() async {
    final XFile? image =
        await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    _profileImage = File(image.path);

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'profile_image',
      image.path,
    );

    notifyListeners();
  }

  // ============================================================
  // UPDATE NAME LOCALLY
  // ============================================================
  //
  // Keep this for now.
  // Later we'll connect name editing to FastAPI.
  //

  Future<void> updateName(
    String newName,
  ) async {
    final name = newName.trim();

    if (name.isEmpty) return;

    _name = name;

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'profile_name',
      name,
    );

    notifyListeners();
  }
}