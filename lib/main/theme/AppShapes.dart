import 'package:flutter/material.dart';
import 'AppColors.dart';

/// 📐 Veloxi — Shapes & Radii (Style A)
@immutable
class AppShapes {
  const AppShapes._();

  // Radii
  static const double rXs   = 8;
  static const double rSm   = 12;
  static const double rMd   = 16;   // ← default
  static const double rLg   = 20;
  static const double rXl   = 24;
  static const double rPill = 999;

  static BorderRadius radiusMd  = BorderRadius.circular(rMd);
  static BorderRadius radiusLg  = BorderRadius.circular(rLg);
  static BorderRadius radiusPill = BorderRadius.circular(rPill);

  // Standard card decoration (light/dark aware)
  static BoxDecoration card({required bool isDark, double radius = rXl}) {
    return BoxDecoration(
      color: AppColors.adaptiveSurface(isDark),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: AppColors.adaptiveBorder(isDark),
        width: isDark ? 0.4 : 1,
      ),
      boxShadow: isDark
          ? null
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
    );
  }

  // Brand gradient CTA decoration
  static BoxDecoration ctaGradient({double radius = rMd, bool withGlow = true}) {
    return BoxDecoration(
      gradient: AppColors.brandGradient,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: withGlow
          ? [
              BoxShadow(
                color: AppColors.brandPrimary.withValues(alpha: 0.32),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ]
          : null,
    );
  }
}

