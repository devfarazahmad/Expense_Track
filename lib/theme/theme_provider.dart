


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = AppTheme.light();

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == AppTheme.dark();

  ThemeProvider() {
    _loadTheme(); 
  }

  void toggleTheme() async {
    _themeData = isDarkMode ? AppTheme.light() : AppTheme.dark();
    notifyListeners();

   
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _themeData == AppTheme.dark());
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    _themeData = isDark ? AppTheme.dark() : AppTheme.light();
    notifyListeners();
  }
}
