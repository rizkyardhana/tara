import 'package:flutter/material.dart';

/// TARA Color Tokens
/// TARA palette: lavender for guidance, plum for readable text, mint for growth.
abstract class TaraColors {
  // Primary Brand Colors
  static const Color purple = Color(0xFF7058D0);
  static const Color blue = Color(0xFF8069E8);
  static const Color green = Color(0xFF328C70);

  // Neutral
  static const Color bgCoolWhite = Color(0xFFF6F5FA);
  static const Color textDeepIndigo = Color(0xFF30283D);
  static const Color textMuted = Color(0xFF716A7B);
  static const Color divider = Color(0xFFE6E2EC);

  // Authentication screens
  static const Color authInk = Color(0xFF30283D);
  static const Color authMuted = Color(0xFF716A7B);
  static const Color authAccent = Color(0xFF8069E8);
  static const Color authBorder = Color(0xFFE6E2EC);
  static const List<Color> authBackgroundGradient = [
    Color(0xFFEAF5F0),
    Color(0xFFF2EFF9),
    Color(0xFFFAF3F5),
  ];
  static const List<Color> authButtonGradient = [
    Color(0xFF8B75EA),
    Color(0xFF7058D0),
  ];

  // Semantic
  static const Color success = green;
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFF87171);
  static const Color info = blue;

  // Brand gradient is reserved for primary actions and identity accents.
  static const List<Color> taraGradient = authButtonGradient;

  // Shadow
  static const Color shadowColor = Color(0x1A000000);
}
