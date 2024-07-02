import 'package:flutter/material.dart';
import 'package:finance_tracker/assets/color_palette.dart';

class NexusTheme {
  final NexusColor nexusColor = NexusColor();
  ThemeData get nexusTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: nexusColor.background,
      primaryColor: NexusColor.secondary,

      textTheme: TextTheme(
        bodyLarge: TextStyle(color: nexusColor.text),
        bodyMedium: TextStyle(color: nexusColor.text),
        bodySmall: TextStyle(color: nexusColor.text),
        displayLarge: TextStyle(color: nexusColor.text),
        displayMedium: TextStyle(color: nexusColor.text),
        displaySmall: TextStyle(color: nexusColor.text),
        titleLarge: TextStyle(color: nexusColor.text),
        titleMedium: TextStyle(color: nexusColor.text),
        titleSmall: TextStyle(color: nexusColor.text),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: nexusColor.inputs,
        filled: true,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: NexusColor.accents),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: nexusColor.divider),
        ),
        labelStyle: TextStyle(color: nexusColor.text),
        helperStyle: TextStyle(color: nexusColor.subText),
        hintStyle: TextStyle(color: nexusColor.text),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: nexusColor.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: nexusColor.navigation,
        elevation: 10.0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: nexusColor.text,
        ),
        titleTextStyle: TextStyle(
          color: nexusColor.text,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
