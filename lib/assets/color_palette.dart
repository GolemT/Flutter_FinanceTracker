import 'package:flutter/material.dart';

class NexusColor extends ChangeNotifier {
  static final NexusColor _instance = NexusColor._internal();
  factory NexusColor() => _instance;
  NexusColor._internal();

  static bool isDark = true;

  static const accents = Color(0xFF623CEA);
  static const secondary = Color(0xFF3185FC);

  Color get background => isDark ? const Color(0xFF272727): const Color(0xFFF0F0F0);
  Color get text => isDark ? const Color(0xFFFAFAFA): const Color(0xFF070707);
  Color get subText => isDark ? const Color(0xFF999999): const Color(0xFF707070);
  Color get navigation => isDark ? const Color(0xFF2F2F2F): const Color(0xFFFAFAFA);
  static const positive = Color(0xFF20BF55);
  static const negative = Color(0xFFDB3A34);
  Color get inputs => isDark ? const Color(0xFF3E3E3E): const Color(0xFFFFFFFF);
  Color get divider => isDark ? const Color(0xFF979797): const Color(0xFF707070);
  Color get dark => isDark ? const Color(0xFF070707): const Color(0xFF3185FC);
  Color get white => isDark ? const Color(0xFFFAFAFA): const Color(0xFF3185FC);
  Color get listBackground => isDark ? const Color(0xFF1C1C1C): const Color(0xFFC9C8C8);

  void updateTheme(bool value) {
    isDark = value;
    notifyListeners();
  }
}
