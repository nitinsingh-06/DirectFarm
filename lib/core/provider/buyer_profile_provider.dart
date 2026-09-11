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

  String _name = 'Priya Sharma';
  String _email = 'priya.sharma@gmail.com';
  String _phone = '+91 98765 43210';
  String _dob = '12/04/1998';
  String _gender = 'Female';

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
      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        debugPrint('No Firebase user is logged in');
        return;
      }

      final firebaseUid = firebaseUser.uid;

      debugPrint('Loading profile for Firebase UID: $firebaseUid');

      final userData = await ApiService.getUserByFirebaseUid(
        firebaseUid: firebaseUid,
      );

      // Load data from FastAPI / PostgreSQL
      _userId = userData['user_id'];

      _name = userData['name'] ?? '';

      _email = userData['email'] ?? '';

      _phone = userData['phone'] ?? '';

      _role = userData['role'] ?? '';

      // Load profile image from local storage
      final prefs = await SharedPreferences.getInstance();

      _profileImage = null;

      final imagePath = prefs.getString('buyer_profile_image');

      if (imagePath != null && imagePath.isNotEmpty) {
        final file = File(imagePath);

        if (await file.exists()) {
          _profileImage = file;
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('LOAD BUYER PROFILE ERROR: $e');
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
