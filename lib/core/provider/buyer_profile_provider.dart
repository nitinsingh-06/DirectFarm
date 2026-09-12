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

      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        debugPrint('NO FIREBASE USER LOGGED IN');
        return;
      }

      final firebaseUid = firebaseUser.uid;

      debugPrint('PROFILE FIREBASE UID: $firebaseUid');

      // ==========================================================
      // LOAD LOGIN DATA FROM SHARED PREFERENCES
      // ==========================================================

      final prefs = await SharedPreferences.getInstance();

      final savedUserId = prefs.getInt('user_id');

      final savedRole = prefs.getString('user_role');

      final savedName = prefs.getString('profile_name');

      final savedEmail = prefs.getString('user_email');

      final savedPhone = prefs.getString('user_phone');

      debugPrint('SAVED USER ID: $savedUserId');

      debugPrint('SAVED ROLE: $savedRole');

      debugPrint('SAVED NAME: $savedName');

      debugPrint('SAVED EMAIL: $savedEmail');

      debugPrint('SAVED PHONE: $savedPhone');

      // ==========================================================
      // USE LOGIN DATA
      // ==========================================================

      if (savedUserId != null) {
        _userId = savedUserId;
      }

      if (savedRole != null && savedRole.isNotEmpty) {
        _role = savedRole;
      }

      if (savedName != null && savedName.isNotEmpty) {
        _name = savedName;
      }

      if (savedEmail != null && savedEmail.isNotEmpty) {
        _email = savedEmail;
      }

      if (savedPhone != null && savedPhone.isNotEmpty) {
        _phone = savedPhone;
      }

      // ==========================================================
      // ALSO FETCH FRESH DATA FROM FASTAPI
      // ==========================================================

      try {
        final userData = await ApiService.getUserByFirebaseUid(
          firebaseUid: firebaseUid,
        );

        debugPrint('PROFILE API RESPONSE: $userData');

        _userId = userData['user_id'];

        _name = userData['name']?.toString() ?? '';

        _email = userData['email']?.toString() ?? '';

        _phone = userData['phone']?.toString() ?? '';

        _role = userData['role']?.toString() ?? '';
      } catch (e) {
        debugPrint('PROFILE API ERROR: $e');

        // Login data remains available.
        debugPrint('USING SAVED LOGIN DATA INSTEAD');
      }

      // ==========================================================
      // LOAD LOCAL PROFILE IMAGE
      // ==========================================================

      _profileImage = null;

      final imagePath = prefs.getString('buyer_profile_image');

      if (imagePath != null && imagePath.isNotEmpty) {
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
      debugPrint('LOAD BUYER PROFILE ERROR: $e');
    }
  }
  // ============================================================
  // PICK + UPLOAD PROFILE IMAGE
  // ============================================================

  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return;

      final file = File(image.path);

      debugPrint('======================================');
      debugPrint('PROFILE IMAGE SELECTED');
      debugPrint('IMAGE PATH: ${file.path}');
      debugPrint('USER ID: $_userId');
      debugPrint('======================================');

      // Make sure we know which database user to update
      if (_userId == null) {
        debugPrint('PROFILE IMAGE ERROR: USER ID IS NULL');
        return;
      }

      // Show selected image immediately
      _profileImage = file;
      notifyListeners();

      // ==========================================================
      // UPLOAD IMAGE TO FASTAPI
      // ==========================================================
      debugPrint('🚀 UPLOADING IMAGE TO FASTAPI...');
      debugPrint('🚀 USER ID: $_userId');
      debugPrint('🚀 IMAGE PATH: ${file.path}');

      final updatedUser = await ApiService.uploadProfileImage(
        userId: _userId!,
        imagePath: file.path,
      );

      debugPrint('✅ API METHOD RETURNED');
      debugPrint('======================================');
      debugPrint('PROFILE IMAGE UPLOAD SUCCESS');
      debugPrint('UPDATED USER: $updatedUser');
      debugPrint('PROFILE IMAGE URL: ${updatedUser['profile_image_url']}');
      debugPrint('======================================');

      // ==========================================================
      // SAVE IMAGE PATH LOCALLY
      // ==========================================================

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('buyer_profile_image', file.path);

      // Save backend URL too
      final imageUrl = updatedUser['profile_image_url']?.toString() ?? '';

      if (imageUrl.isNotEmpty) {
        await prefs.setString('profile_image_url', imageUrl);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('======================================');
      debugPrint('PROFILE IMAGE UPLOAD ERROR: $e');
      debugPrint('======================================');
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

      debugPrint('======================================');
      debugPrint('SAVE PROFILE STARTED');
      debugPrint('NAME: $newName');
      debugPrint('EMAIL: $newEmail');
      debugPrint('PHONE: $newPhone');
      debugPrint('USER ID: $_userId');
      debugPrint('======================================');

      if (newName.isEmpty || newEmail.isEmpty || newPhone.isEmpty) {
        debugPrint('PROFILE VALIDATION FAILED');
        return false;
      }

      if (_userId == null) {
        debugPrint('ERROR: USER ID IS NULL');
        return false;
      }

      // ==========================================
      // SEND DATA TO FASTAPI
      // ==========================================

      debugPrint('CALLING API UPDATE...');

      final updatedUser = await ApiService.updateUser(
        userId: _userId!,
        name: newName,
        email: newEmail,
        phone: newPhone,
      );

      debugPrint('======================================');
      debugPrint('API UPDATE SUCCESS');
      debugPrint('UPDATED USER: $updatedUser');
      debugPrint('======================================');

      // ==========================================
      // UPDATE PROVIDER
      // ==========================================

      _userId = updatedUser['user_id'];

      _name = updatedUser['name']?.toString() ?? newName;

      _email = updatedUser['email']?.toString() ?? newEmail;

      _phone = updatedUser['phone']?.toString() ?? newPhone;

      _dob = dob;
      _gender = gender;

      // ==========================================
      // SAVE LOCAL DATA
      // ==========================================

      await prefs.setString('buyer_name', _name);
      await prefs.setString('buyer_email', _email);
      await prefs.setString('buyer_phone', _phone);
      await prefs.setString('buyer_dob', _dob);
      await prefs.setString('buyer_gender', _gender);

      // Keep login/profile data synchronized
      await prefs.setString('profile_name', _name);
      await prefs.setString('user_email', _email);
      await prefs.setString('user_phone', _phone);

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('======================================');
      debugPrint('SAVE PROFILE ERROR: $e');
      debugPrint('======================================');

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
