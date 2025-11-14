import 'package:flutter/material.dart';

/// App color constants inspired by shadcn design system
class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFFDC2626); // Red-600
  static const Color primaryLight = Color(0xFFEF4444); // Red-500
  static const Color primaryDark = Color(0xFFB91C1C); // Red-700

  // Semantic Colors
  static const Color success = Color(0xFF10B981); // Green-500
  static const Color warning = Color(0xFFF59E0B); // Amber-500
  static const Color error = Color(0xFFEF4444); // Red-500
  static const Color info = Color(0xFF3B82F6); // Blue-500

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFAFAFA);
  static const Color lightSurfaceVariant = Color(0xFFF5F5F5);
  static const Color lightBorder = Color(0xFFE5E5E5);
  static const Color lightText = Color(0xFF18181B); // Zinc-900
  static const Color lightTextSecondary = Color(0xFF71717A); // Zinc-500
  static const Color lightTextMuted = Color(0xFFA1A1AA); // Zinc-400

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF09090B); // Zinc-950
  static const Color darkSurface = Color(0xFF18181B); // Zinc-900
  static const Color darkSurfaceVariant = Color(0xFF27272A); // Zinc-800
  static const Color darkBorder = Color(0xFF3F3F46); // Zinc-700
  static const Color darkText = Color(0xFFFAFAFA); // Zinc-50
  static const Color darkTextSecondary = Color(0xFFA1A1AA); // Zinc-400
  static const Color darkTextMuted = Color(0xFF71717A); // Zinc-500

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Opacity variants
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}
