import 'package:flutter/material.dart';

/// Application Color Palette supporting Light and Dark modes.
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF0F2027);      // Deep Midnight Blue
  static const Color primaryLight = Color(0xFF203A43); // Navy Blue
  static const Color primaryDark = Color(0xFF0D1117);  // Dark Ocean Blue

  // Accent Colors
  static const Color accent = Color(0xFF00D2FF);       // Cyan / Vivid Turquoise
  static const Color accentSecondary = Color(0xFF3A7BD5); // Sky Blue
  static const Color goldAccent = Color(0xFFFFD700);   // Luxury Gold (Favorites/Stars)

  // Dark Theme Palette
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkCardBorder = Color(0xFF30363D);
  static const Color darkTextPrimary = Color(0xFFF0F6FC);
  static const Color darkTextSecondary = Color(0xFF8B949E);

  // Light Theme Palette
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCardBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Status Colors
  static const Color success = Color(0xFF2EA043);
  static const Color warning = Color(0xFFD29922);
  static const Color error = Color(0xFFF85149);
}
