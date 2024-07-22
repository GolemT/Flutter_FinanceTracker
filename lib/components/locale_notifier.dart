import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleNotifier() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('lang');
    if (lang != null) {
      setLocale(Locale(lang));
    }
  }

  void setLocale(Locale locale) async {
    if (locale != _locale) {
      _locale = locale;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('lang', locale.languageCode);
      notifyListeners();
    }
  }
}
