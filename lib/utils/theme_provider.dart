import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  final String key = 'theme_mode';
  late SharedPreferences prefs;
  late ThemeMode _themeMode;
  
  ThemeMode get themeMode => _themeMode;
  
  ThemeProvider() {
    _themeMode = ThemeMode.dark;
    _loadFromPreferences();
  }
  
  // Load theme mode from shared preferences
  _loadFromPreferences() async {
    prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key) ?? 'dark';
    _themeMode = _getThemeMode(value);
    notifyListeners();
  }
  
  // Save theme mode to shared preferences
  _saveToPreferences() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(key, _getThemeModeString(_themeMode));
  }
  
  // Toggle between light and dark mode
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveToPreferences();
    notifyListeners();
  }
  
  // Convert string to ThemeMode enum
  ThemeMode _getThemeMode(String themeModeString) {
    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }
  
  // Convert ThemeMode enum to string
  String _getThemeModeString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
      default:
        return 'dark';
    }
  }
}