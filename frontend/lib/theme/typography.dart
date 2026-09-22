import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// TARA Typography System
/// Font: Plus Jakarta Sans (extrabold untuk judul, regular untuk teks)
abstract class TaraTypography {
  // Heading Styles
  static TextStyle heading1(BuildContext context) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 32,
      fontWeight: FontWeight.w800, // extrabold
      height: 1.2,
      letterSpacing: -0.5,
    );
  }

  static TextStyle heading2(BuildContext context) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 24,
      fontWeight: FontWeight.w700, // bold
      height: 1.3,
      letterSpacing: -0.3,
    );
  }

  static TextStyle heading3(BuildContext context) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 18,
      fontWeight: FontWeight.w700, // bold
      height: 1.4,
    );
  }

  // Body Text
  static TextStyle bodyLarge(BuildContext context) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    );
  }

  static TextStyle bodyRegular(BuildContext context) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.4,
    );
  }

  // Button Text
  static TextStyle buttonText(BuildContext context) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
    );
  }

  // Caption
  static TextStyle caption(BuildContext context) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.3,
    );
  }
}
