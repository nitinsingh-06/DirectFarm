import 'dart:io';

import 'package:farmdirect/config/api_config.dart';
import 'package:farmdirect/services/api_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerProfileProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  // ============================================================
  // VARIABLES
  // ============================================================

  File? _profileImage;

  int? _userId;

  String _role = '';

  String _name = '';

  String _email = '';

  String _phone = '';

  String _dob = '';

  String _gender = '';

  String _profileImageUrl = '';

  // ============================================================
  // GETTERS
  // ============================================================

  File? get profileImage => _profileImage;

  int? get userId => _userId;

  String get role => _role;

  String get name => _name;

  String get email => _email;

  String get phone => _phone;

  String get dob => _dob;

  String get gender => _gender;

  String get profileImageUrl => _profileImageUrl;

  String get defaultImage => 'assets/images/profile.png';

  // ============================================================
  // COMPLETE BACKEND IMAGE URL
  // ============================================================

String get fullProfileImageUrl {
  if (_profileImageUrl.isEmpty) {
    return '';
  }

  if (_profileImageUrl.startsWith('http')) {
    return _profileImageUrl;
  }

  return '${ApiConfig.baseUrl}$_profileImageUrl';
}

  // ============================================================
  // LOAD PROFILE
  // ============================================================

  Future<void> loadProfile() async {
    try {
      // ==========================================================
      // GET CURRENT FIREBASE USER
      // ==========================================================

      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        debugPrint('NO FIREBASE USER LOGGED IN');
        return;
      }

      final firebaseUid = firebaseUser.uid;

      debugPrint('======================================');
      debugPrint('LOADING BUYER PROFILE');
      debugPrint('FIREBASE UID: $firebaseUid');
      debugPrint('======================================');

      // ==========================================================
      // SHARED PREFERENCES
      // ==========================================================

      final prefs = await SharedPreferences.getInstance();

      final savedUserId = prefs.getInt('user_id');

      final savedRole = prefs.getString('user_role');

      final savedName = prefs.getString('profile_name');

      final savedEmail = prefs.getString('user_email');

      final savedPhone = prefs.getString('user_phone');

      final savedImageUrl = prefs.getString('profile_image_url');

      debugPrint('SAVED USER ID: $savedUserId');

      debugPrint('SAVED ROLE: $savedRole');

      debugPrint('SAVED NAME: $savedName');

      debugPrint('SAVED EMAIL: $savedEmail');

      debugPrint('SAVED PHONE: $savedPhone');

      debugPrint('SAVED IMAGE URL: $savedImageUrl');

      // ==========================================================
      // USE SAVED LOGIN DATA FIRST
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

      if (savedImageUrl != null && savedImageUrl.isNotEmpty) {
        _profileImageUrl = savedImageUrl;
      }

      // ==========================================================
      // GET FRESH DATA FROM FASTAPI
      // ==========================================================

      try {
        final userData =
            await ApiService.getUserByFirebaseUid(
          firebaseUid: firebaseUid,
        );

        debugPrint('======================================');
        debugPrint('PROFILE API RESPONSE');
        debugPrint('$userData');
        debugPrint('======================================');

        // ========================================================
        // BASIC PROFILE DATA
        // ========================================================

        _userId = userData['user_id'];

        _name =
            userData['name']?.toString() ?? '';

        _email =
            userData['email']?.toString() ?? '';

        _phone =
            userData['phone']?.toString() ?? '';

        _role =
            userData['role']?.toString() ?? '';

        // ========================================================
        // BACKEND PROFILE IMAGE
        // ========================================================

        _profileImageUrl =
            userData['profile_image_url']?.toString() ?? '';

        debugPrint(
          'PROFILE IMAGE URL FROM API: $_profileImageUrl',
        );

        debugPrint(
          'FULL PROFILE IMAGE URL: $fullProfileImageUrl',
        );

        // ========================================================
        // SAVE FRESH DATA LOCALLY
        // ========================================================

        await prefs.setInt(
          'user_id',
          _userId!,
        );

        await prefs.setString(
          'user_role',
          _role,
        );

        await prefs.setString(
          'profile_name',
          _name,
        );

        await prefs.setString(
          'user_email',
          _email,
        );

        await prefs.setString(
          'user_phone',
          _phone,
        );

        if (_profileImageUrl.isNotEmpty) {
          await prefs.setString(
            'profile_image_url',
            _profileImageUrl,
          );
        } else {
          await prefs.remove(
            'profile_image_url',
          );
        }
      } catch (e) {
        debugPrint('======================================');
        debugPrint('PROFILE API ERROR: $e');
        debugPrint('USING SAVED DATA');
        debugPrint('======================================');
      }

      // ==========================================================
      // DO NOT LOAD OLD LOCAL PROFILE IMAGE
      // ==========================================================
      //
      // The backend is now the source of truth.
      //
      // We intentionally do NOT load:
      //
      // buyer_profile_image
      //
      // here.
      //
      // ==========================================================

      _profileImage = null;

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
  // PICK + UPLOAD PROFILE IMAGE
  // ============================================================

  Future<void> pickProfileImage() async {
    try {
      // ==========================================================
      // PICK IMAGE
      // ==========================================================

      final XFile? image =
          await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) {
        return;
      }

      final file = File(image.path);

      debugPrint('======================================');
      debugPrint('PROFILE IMAGE SELECTED');
      debugPrint('IMAGE PATH: ${file.path}');
      debugPrint('USER ID: $_userId');
      debugPrint('======================================');

      // ==========================================================
      // CHECK USER ID
      // ==========================================================

      if (_userId == null) {
        debugPrint(
          'PROFILE IMAGE ERROR: USER ID IS NULL',
        );

        return;
      }

      // ==========================================================
      // SHOW IMAGE IMMEDIATELY
      // ==========================================================

      _profileImage = file;

      notifyListeners();

      // ==========================================================
      // UPLOAD TO FASTAPI
      // ==========================================================

      debugPrint(
        'UPLOADING IMAGE TO FASTAPI...',
      );

      final updatedUser =
          await ApiService.uploadProfileImage(
        userId: _userId!,
        imagePath: file.path,
      );

      // ==========================================================
      // GET BACKEND IMAGE URL
      // ==========================================================

      _profileImageUrl =
          updatedUser['profile_image_url']
                  ?.toString() ??
              '';

      debugPrint('======================================');
      debugPrint('PROFILE IMAGE UPLOAD SUCCESS');
      debugPrint(
        'UPDATED USER: $updatedUser',
      );
      debugPrint(
        'PROFILE IMAGE URL: $_profileImageUrl',
      );
      debugPrint(
        'FULL IMAGE URL: $fullProfileImageUrl',
      );
      debugPrint('======================================');

      // ==========================================================
      // SAVE BACKEND IMAGE URL LOCALLY
      // ==========================================================

      final prefs =
          await SharedPreferences.getInstance();

      if (_profileImageUrl.isNotEmpty) {
        await prefs.setString(
          'profile_image_url',
          _profileImageUrl,
        );
      }

      // ==========================================================
      // OPTIONAL LOCAL PATH
      // ==========================================================
      //
      // This is only kept for the current session/immediate
      // display. Backend URL remains the source of truth.
      //
      // ==========================================================

      await prefs.setString(
        'buyer_profile_image',
        file.path,
      );

      // ==========================================================
      // REFRESH UI
      // ==========================================================

      notifyListeners();
    } catch (e) {
      debugPrint('======================================');
      debugPrint(
        'PROFILE IMAGE UPLOAD ERROR: $e',
      );
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
      final prefs =
          await SharedPreferences.getInstance();

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

      // ==========================================================
      // VALIDATION
      // ==========================================================

      if (newName.isEmpty ||
          newEmail.isEmpty ||
          newPhone.isEmpty) {
        debugPrint(
          'PROFILE VALIDATION FAILED',
        );

        return false;
      }

      if (_userId == null) {
        debugPrint(
          'ERROR: USER ID IS NULL',
        );

        return false;
      }

      // ==========================================================
      // UPDATE FASTAPI
      // ==========================================================

      debugPrint(
        'CALLING API UPDATE...',
      );

      final updatedUser =
          await ApiService.updateUser(
        userId: _userId!,
        name: newName,
        email: newEmail,
        phone: newPhone,
      );

      debugPrint('======================================');
      debugPrint('API UPDATE SUCCESS');
      debugPrint(
        'UPDATED USER: $updatedUser',
      );
      debugPrint('======================================');

      // ==========================================================
      // UPDATE PROVIDER
      // ==========================================================

      _userId =
          updatedUser['user_id'];

      _name =
          updatedUser['name']?.toString() ??
              newName;

      _email =
          updatedUser['email']?.toString() ??
              newEmail;

      _phone =
          updatedUser['phone']?.toString() ??
              newPhone;

      _dob = dob;

      _gender = gender;

      // ==========================================================
      // GET IMAGE URL IF API RETURNS IT
      // ==========================================================

      if (updatedUser.containsKey(
        'profile_image_url',
      )) {
        _profileImageUrl =
            updatedUser['profile_image_url']
                    ?.toString() ??
                '';
      }

      // ==========================================================
      // SAVE PROFILE DATA LOCALLY
      // ==========================================================

      await prefs.setString(
        'buyer_name',
        _name,
      );

      await prefs.setString(
        'buyer_email',
        _email,
      );

      await prefs.setString(
        'buyer_phone',
        _phone,
      );

      await prefs.setString(
        'buyer_dob',
        _dob,
      );

      await prefs.setString(
        'buyer_gender',
        _gender,
      );

      // ==========================================================
      // KEEP LOGIN DATA SYNCHRONIZED
      // ==========================================================

      await prefs.setString(
        'profile_name',
        _name,
      );

      await prefs.setString(
        'user_email',
        _email,
      );

      await prefs.setString(
        'user_phone',
        _phone,
      );

      // ==========================================================
      // REFRESH UI
      // ==========================================================

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('======================================');
      debugPrint(
        'SAVE PROFILE ERROR: $e',
      );
      debugPrint('======================================');

      return false;
    }
  }

  // ============================================================
  // REMOVE PROFILE IMAGE
  // ============================================================

  Future<void> removeProfileImage() async {
    try {
      final prefs =
          await SharedPreferences.getInstance();

      // Remove local values
      await prefs.remove(
        'buyer_profile_image',
      );

      await prefs.remove(
        'profile_image_url',
      );

      // Clear provider values
      _profileImage = null;

      _profileImageUrl = '';

      notifyListeners();

      debugPrint(
        'PROFILE IMAGE REMOVED LOCALLY',
      );

      // ==========================================================
      // IMPORTANT
      // ==========================================================
      //
      // At this point we have NOT created a DELETE endpoint
      // on FastAPI yet.
      //
      // Therefore this only removes the image from Flutter.
      //
      // We can add backend deletion next.
      //
      // ==========================================================
    } catch (e) {
      debugPrint(
        'REMOVE PROFILE IMAGE ERROR: $e',
      );
    }
  }
}