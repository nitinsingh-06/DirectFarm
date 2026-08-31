import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  File? _profileImage;

  String _name = 'Romesh Kumar';

  File? get profileImage => _profileImage;

  String get name => _name;

  String get defaultImage =>
      'assets/images/profile.png';

  // Load saved profile
  Future<void> loadProfile() async {
    final prefs =
        await SharedPreferences.getInstance();

    _name = prefs.getString('profile_name') ??
        'Romesh Kumar';

    final imagePath =
        prefs.getString('profile_image');

    if (imagePath != null &&
        imagePath.isNotEmpty) {
      final file = File(imagePath);

      if (await file.exists()) {
        _profileImage = file;
      }
    }

    notifyListeners();
  }

  // Pick image
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

  // Update name
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