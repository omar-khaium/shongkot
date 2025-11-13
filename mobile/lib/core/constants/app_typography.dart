import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system for the app
class AppTypography {
  // Font weights
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Base text style
  static TextStyle baseTextStyle({Color? color}) =>
      GoogleFonts.inter(color: color, fontWeight: regular);

  // Display styles (large text)
  static TextStyle display({Color? color}) => baseTextStyle(
    color: color,
  ).copyWith(fontSize: 32, fontWeight: bold, height: 1.2, letterSpacing: -0.5);

  // Heading styles
  static TextStyle h1({Color? color}) => baseTextStyle(
    color: color,
  ).copyWith(fontSize: 28, fontWeight: bold, height: 1.3, letterSpacing: -0.5);

  static TextStyle h2({Color? color}) => baseTextStyle(
    color: color,
  ).copyWith(fontSize: 24, fontWeight: semibold, height: 1.3);

  static TextStyle h3({Color? color}) => baseTextStyle(
    color: color,
  ).copyWith(fontSize: 20, fontWeight: semibold, height: 1.4);

  static TextStyle h4({Color? color}) => baseTextStyle(
    color: color,
  ).copyWith(fontSize: 18, fontWeight: semibold, height: 1.4);

  // Body styles
  static TextStyle bodyLarge({Color? color}) =>
      baseTextStyle(color: color).copyWith(fontSize: 16, height: 1.5);

  static TextStyle bodyMedium({Color? color}) =>
      baseTextStyle(color: color).copyWith(fontSize: 14, height: 1.5);

  static TextStyle bodySmall({Color? color}) =>
      baseTextStyle(color: color).copyWith(fontSize: 12, height: 1.5);

  // Label styles
  static TextStyle label({Color? color}) => baseTextStyle(
    color: color,
  ).copyWith(fontSize: 14, fontWeight: medium, height: 1.4);

  static TextStyle labelSmall({Color? color}) => baseTextStyle(
    color: color,
  ).copyWith(fontSize: 12, fontWeight: medium, height: 1.4);

  // Caption
  static TextStyle caption({Color? color}) =>
      baseTextStyle(color: color).copyWith(fontSize: 12, height: 1.4);

  // Button text
  static TextStyle button({Color? color}) =>
      baseTextStyle(color: color).copyWith(
        fontSize: 14,
        fontWeight: semibold,
        height: 1.2,
        letterSpacing: 0.5,
      );
}
