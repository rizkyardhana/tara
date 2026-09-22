import 'package:flutter/material.dart';

/// TARA Color Tokens
/// Filosofi: ungu (pikiran) → biru (ketenangan) → hijau (pertumbuhan)
abstract class TaraColors {
  // Primary Brand Colors
  static const Color purple = Color(0xFF7A57D1);      // Pikiran, kesadaran, refleksi
  static const Color blue = Color(0xFF2091B6);        // PRIMARY - ketenangan, komunikasi, kepercayaan
  static const Color green = Color(0xFF2F9E63);       // Pertumbuhan, pemulihan, harapan

  // Neutral
  static const Color bgCoolWhite = Color(0xFFF1F5FB); // Background
  static const Color textDeepIndigo = Color(0xFF25315C); // Text utama
  static const Color textMuted = Color(0xFF6C7594);   // Text sekunder
  static const Color divider = Color(0xFFE1E7F1);     // Border, divider

  // Semantic
  static const Color success = green;
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFF87171);
  static const Color info = blue;

  // Gradient: purple → blue → green (TARA signature)
  static const List<Color> taraGradient = [purple, blue, green];

  // Shadow
  static const Color shadowColor = Color(0x1A000000);
}
