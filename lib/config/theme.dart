import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    primaryColor: const Color.fromARGB(255, 169, 20, 20),
    primaryColorDark: const Color.fromARGB(255, 115, 1, 1),
    primaryColorLight: const Color(0xFFFE9AAA),
    cardColor: const Color.fromARGB(255, 37, 212, 231),
    focusColor: const Color.fromARGB(255, 106, 0, 255),
    shadowColor: const Color(0xFFF4F4F4),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Optima',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Color(0xFF2B2E4A),
        fontWeight: FontWeight.bold,
        fontSize: 36,
      ),
      displayMedium: TextStyle(
        color: Color.fromARGB(255, 0, 0, 0),
        fontWeight: FontWeight.bold,
        fontSize: 28,
      ),
      displaySmall: TextStyle(
        color: Color(0xFF2B2E4A),
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      headlineLarge: TextStyle(
        color: Color(0xFF2B2E4A),
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF2B2E4A),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      headlineSmall: TextStyle(
        color: Color(0xFF2B2E4A),
        fontWeight: FontWeight.normal,
        fontSize: 12,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF2B2E4A),
        fontWeight: FontWeight.normal,
        fontSize: 10,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF2B2E4A),
        fontWeight: FontWeight.normal,
        fontSize: 8,
      ),
    ),
  );
}
