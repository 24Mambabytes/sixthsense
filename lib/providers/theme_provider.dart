import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// theme provider
final themeProvider = ChangeNotifierProvider<ThemeNotifier>(
      (_) => ThemeNotifier(),
);

class ThemeNotifier with ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeNotifier() {
    loadPrefs();
  }

  // toggle theme mode
  void toggleTheme() async {
    _isDark = !_isDark;
    notifyListeners();
    setPrefs();
  }

  // load user prefs
  Future<void> loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('themeMode') ?? false;
    notifyListeners();
  }

  // set user prefs
  Future<void> setPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('themeMode', _isDark);
  }
}