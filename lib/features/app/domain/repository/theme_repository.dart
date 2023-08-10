import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  final _pref = SharedPreferences.getInstance();
  bool? dark;

  ThemeNotifier() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    dark = (await _pref).getBool(key) ?? true;
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    (await _pref).setBool(key, dark!);
  }

  void toggleTheme() {
    dark = !dark!;
    _saveToPrefs();
    notifyListeners();
  }
}
