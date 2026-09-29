import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _selectedLocale = const Locale('hi');

  Locale get selectedLocale => _selectedLocale;

  static const List<Map<String, String>> languages = [
    {
      'name': 'हिंदी',
      'local': 'hi',
    },
    {
      'name': 'English',
      'local': 'en',
    },
  ];

  void changeLanguage(String languageCode) {
    if (_selectedLocale.languageCode == languageCode) return;

    _selectedLocale = Locale(languageCode);
    notifyListeners();
  }
}