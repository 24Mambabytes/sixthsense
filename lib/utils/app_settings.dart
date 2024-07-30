import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsManager extends ChangeNotifier {
  ThemeMode _currentTheme = ThemeMode.light;
  ThemeMode get currentTheme => _currentTheme;

  // toggle theme
  void toggleTheme() async {
    // TODO: persist the current theme
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_currentTheme == ThemeMode.light) {
      _currentTheme = ThemeMode.dark;
      prefs.setBool('is_dark', true);
    } else {
      _currentTheme = ThemeMode.light;
      prefs.setBool('is_dark', false);
    }
    notifyListeners();
  }

  // TODO: add settings for text to speech engine
}
