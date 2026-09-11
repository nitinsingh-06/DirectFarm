import 'dart:io';

import 'package:farmdirect/services/api_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerProfileProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  File? _profileImage;
  int? _userId;
  String _role = '';
  String _name = '';
  String _email = '';
  String _phone = '';
  String _dob = '';
  String _gender = '';

  // ============================================================
  // GETTERS
  // ============================================================

  File? get profileImage => _profileImage;

  String get name => _name;
  int? get userId => _userId;

  String get role => _role;

  String get email => _email;

  String get phone => _phone;

  String get dob => _dob;

  String get gender => _gender;

  String get defaultImage => 'assets/images/profile.png';

  // ============================================================
  // LOAD PROFILE
  // ============================================================
  Future<void> loadProfile() async {
  try {
    // ==========================================================
    // GET FIREBASE USER
    // ==========================================================

    final firebaseUser =
        FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      debugPrint('NO FIREBASE USER LOGGED IN');
      return;
    }

    final firebaseUid = firebaseUser.uid;

    debugPrint(
      'PROFILE FIREBASE UID: $firebaseUid',
    );

    // ==========================================================
    // LOAD LOGIN DATA FROM SHARED PREFERENCES
    // ==========================================================

    final prefs =
        await SharedPreferences.getInstance();

    final savedUserId =
        prefs.getInt('user_id');

    final savedRole =
        prefs.getString('user_role');

    final savedName =
        prefs.getString('profile_name');

    final savedEmail =
        prefs.getString('user_email');

    final savedPhone =
        prefs.getString('user_phone');

    debugPrint(
      'SAVED USER ID: $savedUserId',
    );

    debugPrint(
      'SAVED ROLE: $savedRole',
    );

    debugPrint(
      'SAVED NAME: $savedName',
    );

    debugPrint(
      'SAVED EMAIL: $savedEmail',
    );

    debugPrint(
      'SAVED PHONE: $savedPhone',
    );

    // ==========================================================
    // USE LOGIN DATA
    // ==========================================================

    if (savedUserId != null) {
      _userId = savedUserId;
    }

    if (savedRole != null &&
        savedRole.isNotEmpty) {
      _role = savedRole;
    }

    if (savedName != null &&
        savedName.isNotEmpty) {
      _name = savedName;
    }

    if (savedEmail != null &&
        savedEmail.isNotEmpty) {
      _email = savedEmail;
    }

    if (savedPhone != null &&
        savedPhone.isNotEmpty) {
      _phone = savedPhone;
    }

    // ==========================================================
    // ALSO FETCH FRESH DATA FROM FASTAPI
    // ==========================================================

    try {
      final userData =
          await ApiService.getUserByFirebaseUid(
        firebaseUid: firebaseUid,
      );

      debugPrint(
        'PROFILE API RESPONSE: $userData',
      );

      _userId =
          userData['user_id'];

      _name =
          userData['name']?.toString() ?? '';

      _email =
          userData['email']?.toString() ?? '';

      _phone =
          userData['phone']?.toString() ?? '';

      _role =
          userData['role']?.toString() ?? '';

    } catch (e) {
      debugPrint(
        'PROFILE API ERROR: $e',
      );

      // Login data remains available.
      debugPrint(
        'USING SAVED LOGIN DATA INSTEAD',
      );
    }

    // ==========================================================
    // LOAD LOCAL PROFILE IMAGE
    // ==========================================================

    _profileImage = null;

    final imagePath =
        prefs.getString(
      'buyer_profile_image',
    );

    if (imagePath != null &&
        imagePath.isNotEmpty) {
      final file = File(imagePath);

      if (await file.exists()) {
        _profileImage = file;
      }
    }

    // ==========================================================
    // REFRESH UI
    // ==========================================================

    notifyListeners();

  } catch (e) {
    debugPrint(
      'LOAD BUYER PROFILE ERROR: $e',
    );
  }
}
  // ============================================================
  // PICK PROFILE IMAGE
  // ============================================================

  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return;

      final file = File(image.path);

      // Update immediately
      _profileImage = file;

      // Save path permanently
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('buyer_profile_image', file.path);

      // Refresh all screens using provider
      notifyListeners();
    } catch (e) {
      debugPrint('PROFILE IMAGE ERROR: $e');
    }
  }

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  Future<bool> saveProfile({
    required String name,
    required String email,
    required String phone,
    required String dob,
    required String gender,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final newName = name.trim();
      final newEmail = email.trim();
      final newPhone = phone.trim();

      if (newName.isEmpty || newEmail.isEmpty || newPhone.isEmpty) {
        return false;
      }

      // Update provider
      _name = newName;
      _email = newEmail;
      _phone = newPhone;
      _dob = dob;
      _gender = gender;

      // Save permanently
      await prefs.setString('buyer_name', _name);

      await prefs.setString('buyer_email', _email);

      await prefs.setString('buyer_phone', _phone);

      await prefs.setString('buyer_dob', _dob);

      await prefs.setString('buyer_gender', _gender);

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('SAVE PROFILE ERROR: $e');

      return false;
    }
  }

  // ============================================================
  // CLEAR PROFILE IMAGE
  // ============================================================

  Future<void> removeProfileImage() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('buyer_profile_image');

    _profileImage = null;

    notifyListeners();
  }
}
