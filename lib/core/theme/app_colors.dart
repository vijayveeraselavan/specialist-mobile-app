import 'package:flutter/material.dart';

class AppColors {
  // Private constructor
  AppColors._();

  // Primary Colors - Healthcare themed
  static const Color primary = Color(0xFF2E86AB);      // Medical blue
  static const Color primaryLight = Color(0xFF5BA7CC);
  static const Color primaryDark = Color(0xFF1E5F7A);
  
  // Secondary/Accent Colors
  static const Color accent = Color(0xFF00C896);       // Health green
  static const Color accentLight = Color(0xFF33D4A9);
  static const Color accentDark = Color(0xFF009674);

  // Neutral Colors - Light Theme
  static const Color lightBackground = Color(0xFFFAFBFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color onLightBackground = Color(0xFF1A1D21);
  static const Color onLightSurface = Color(0xFF1A1D21);

  // Neutral Colors - Dark Theme
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color onDarkBackground = Color(0xFFF0F6FC);
  static const Color onDarkSurface = Color(0xFFF0F6FC);

  // Common Surface Colors
  static const Color surface = Color(0xFFF8F9FA);
  static const Color outline = Color(0xFFD0D7DE);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1D21);
  static const Color textSecondary = Color(0xFF6E7681);
  static const Color textTertiary = Color(0xFF8B949E);
  static const Color textInverse = Color(0xFFF0F6FC);

  // Status Colors
  static const Color success = Color(0xFF238636);
  static const Color warning = Color(0xFFD29922);
  static const Color error = Color(0xFFDA3633);
  static const Color info = Color(0xFF0969DA);

  // On Status Colors
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color onWarning = Color(0xFF000000);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onInfo = Color(0xFFFFFFFF);

  // Border Colors
  static const Color borderLight = Color(0xFFD0D7DE);
  static const Color borderDark = Color(0xFF30363D);

  // Divider Colors
  static const Color dividerLight = Color(0xFFE1E4E8);
  static const Color dividerDark = Color(0xFF21262D);

  // Healthcare Specific Colors
  static const Color heartRate = Color(0xFFE74C3C);
  static const Color bloodPressure = Color(0xFF3498DB);
  static const Color temperature = Color(0xFFF39C12);
  static const Color oxygen = Color(0xFF27AE60);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF2E86AB),
    Color(0xFF00C896),
  ];

  static const List<Color> backgroundGradient = [
    Color(0xFFFAFBFC),
    Color(0xFFF0F6FC),
  ];

  static const List<Color> cardGradient = [
    Color(0xFFFFFFFF),
    Color(0xFFF8F9FA),
  ];

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x40000000);

  // Overlay Colors
  static const Color overlayLight = Color(0x80FFFFFF);
  static const Color overlayDark = Color(0x80000000);
}