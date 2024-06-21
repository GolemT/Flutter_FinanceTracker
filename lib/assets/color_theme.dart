import 'package:flutter/material.dart';
import 'package:finance_tracker/assets/color_palette.dart';

class NexusTheme {
  static ThemeData get nexusTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: NexusColor.background,
      primaryColor: NexusColor.secondary,

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
        filled: true,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: NexusColor.accents),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: NexusColor.divider),
        ),
        labelStyle: TextStyle(color: NexusColor.text),
        filled: true,
        helperStyle: TextStyle(color: NexusColor.subText),
        hintStyle: TextStyle(color: NexusColor.text),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: NexusColor.accents),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: NexusColor.divider),
        ),
        labelStyle: TextStyle(color: NexusColor.text),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: NexusColor.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: NexusColor.navigation,
        elevation: 10.0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
