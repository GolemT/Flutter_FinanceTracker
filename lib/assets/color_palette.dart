import 'dart:ui';

class NexusColor {
  static const bool isDark = true;
  static const accents = Color(0xFF623CEA);
  static const secondary = Color(0xFF3185FC);
  static const background = isDark ? Color(0xFF272727): Color(0xFFF0F0F0);
  static const text = isDark ? Color(0xFFFAFAFA): Color(0xFF070707);
  static const subText = isDark ? Color(0xFF999999): Color(0xFF707070);
  static const navigation = isDark ? Color(0xFF2F2F2F): Color(0xFFFAFAFA);
  static const positive = Color(0xFF20BF55);
  static const negative = Color(0xFFDB3A34);
  static const inputs = isDark ? Color(0xFF3E3E3E): Color(0xFFFFFFFF);
  static const divider = isDark ? Color(0xFF979797): Color(0xFF707070);
  static const dark = isDark ? Color(0xFF070707): Color(0xFF3185FC);
  static const white = isDark ? Color(0xFFFAFAFA): Color(0xFF3185FC);
  static const listBackground = isDark ? Color(0xFF1C1C1C): Color(0xFFC9C8C8);

}