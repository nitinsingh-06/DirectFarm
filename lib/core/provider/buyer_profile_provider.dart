
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerProfileProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  File? _profileImage;

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

  String get email => _email;

  String get phone => _phone;

  String get dob => _dob;

  String get gender => _gender;

  String get defaultImage =>
      'assets/images/profile.png';

  // ============================================================
  // LOAD PROFILE
  // ============================================================

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    _name = prefs.getString('buyer_name') ??
        'Priya Sharma';

    _email = prefs.getString('buyer_email') ??
        'priya.sharma@gmail.com';

    _phone = prefs.getString('buyer_phone') ??
        '+91 98765 43210';

    _dob = prefs.getString('buyer_dob') ??
        '12/04/1998';

    _gender = prefs.getString('buyer_gender') ??
        'Female';

    // Reset first
    _profileImage = null;

    final imagePath =
        prefs.getString('buyer_profile_image');

    if (imagePath != null &&
        imagePath.isNotEmpty) {
      final file = File(imagePath);

      if (await file.exists()) {
        _profileImage = file;
      }
    }

    notifyListeners();
  }

  // ============================================================
  // PICK PROFILE IMAGE
  // ============================================================

  Future<void> pickProfileImage() async {
    try {
      final XFile? image =
          await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return;

      final file = File(image.path);

      // Update immediately
      _profileImage = file;

      // Save path permanently
      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        'buyer_profile_image',
        file.path,
      );

      // Refresh all screens using provider
      notifyListeners();
    } catch (e) {
      debugPrint(
        'PROFILE IMAGE ERROR: $e',
      );
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

      if (newName.isEmpty ||
          newEmail.isEmpty ||
          newPhone.isEmpty) {
        return false;
      }

      // Update provider
      _name = newName;
      _email = newEmail;
      _phone = newPhone;
      _dob = dob;
      _gender = gender;

      // Save permanently
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

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint(
        'SAVE PROFILE ERROR: $e',
      );

      return false;
    }
  }

  // ============================================================
  // CLEAR PROFILE IMAGE
  // ============================================================

  Future<void> removeProfileImage() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      'buyer_profile_image',
    );

    _profileImage = null;

    notifyListeners();
  }
}
