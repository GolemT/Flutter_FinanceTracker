import 'package:finance_tracker/assets/color_palette.dart';
import 'package:flutter/material.dart';

class NexusTheme {
  static ThemeData get nexusTheme{
    return ThemeData(
      scaffoldBackgroundColor: NexusColor.background,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: NexusColor.text),
        bodyMedium: TextStyle(color: NexusColor.text),
        bodySmall: TextStyle(color: NexusColor.text),
        displayLarge: TextStyle(color: NexusColor.text),
        displayMedium: TextStyle(color: NexusColor.text),
        displaySmall: TextStyle(color: NexusColor.text),
        titleLarge: TextStyle(color: NexusColor.text),
        titleMedium: TextStyle(color: NexusColor.text),
        titleSmall: TextStyle(color: NexusColor.text),

      ),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: NexusColor.inputs,
        helperStyle: TextStyle(color: NexusColor.subText),
        hintStyle: TextStyle(color: NexusColor.text),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: NexusColor.white,
      ),
    );
  }
}