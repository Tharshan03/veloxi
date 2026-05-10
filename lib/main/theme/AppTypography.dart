import 'package:flutter/material.dart';
import 'AppColors.dart';

/// ✏️ Veloxi — Typography (Style A · Brand Aurora)
///
/// We don't switch font family yet (would require asset + pubspec change).
/// We expose a consistent type scale built on the current default font.
@immutable
class AppTypography {
  const AppTypography._();

  // Display
  static TextStyle displayLg({Color? color}) => TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: color ?? AppColors.textPrimary,
        letterSpacing: -0.5,
        height: 1.15,
      );

  // Titles
  static TextStyle titleLg({Color? color}) => TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle titleMd({Color? color}) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary,
      );

  // Body
  static TextStyle bodyLg({Color? color}) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle bodyMd({Color? color}) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textPrimary,
        height: 1.4,
      );

  // Caption / labels
  static TextStyle label({Color? color}) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textSecondary,
        letterSpacing: 0.2,
      );

  // Numbers (prices, distances) — tabular feeling
  static TextStyle numeric({double size = 18, Color? color}) => TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}

