import 'package:flutter/material.dart';
import '../utils/dynamic_theme.dart';

/// 🎨 Veloxi — Brand Aurora (Style A)
///
/// Single source of truth for **brand semantics**.
/// We do NOT replace [ColorUtils] (legacy) — we **wrap** it so existing
/// screens keep working while new code can use these semantic tokens.
///
/// Whenever you need a brand color in new code:
///   import 'package:.../main/theme/AppColors.dart';
///   AppColors.brandPrimary
///   AppColors.brandGradient
@immutable
class AppColors {
  const AppColors._();

  // ─── Brand ──────────────────────────────────────────────
  static const Color brandPrimary   = Color(0xFF12C7B0); // teal
  static const Color brandSecondary = Color(0xFF0088FF); // blue
  static const Color brandAccent    = Color(0xFF00E0B8); // success / "online"

  /// Main CTA gradient (left → right).
  /// Aliased on [ColorUtils.tealGradient] for backward compat.
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [brandPrimary, brandSecondary],
  );

  // ─── Surfaces (light) ───────────────────────────────────
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color surfaceAlt    = Color(0xFFF0FDFB); // chip / soft bg
  static const Color border        = Color(0xFFD1FAF4);

  // ─── Surfaces (dark) ────────────────────────────────────
  static const Color darkBg        = Color(0xFF0F172A);
  static const Color darkSurface   = Color(0xFF1E293B);
  static const Color darkSurfaceHi = Color(0xFF263248);
  static const Color darkBorder    = Color(0xFF334155);

  // ─── Text ───────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textInverse   = Color(0xFFFFFFFF);

  // ─── Semantic ───────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFFFB020);
  static const Color danger  = Color(0xFFEF4444);
  static const Color info    = brandSecondary;

  // ─── Helpers ────────────────────────────────────────────
  /// Returns the right surface depending on the current theme mode.
  static Color adaptiveSurface(bool isDark) => isDark ? darkSurface : surface;
  static Color adaptiveBorder(bool isDark)  => isDark ? darkBorder  : border;
  static Color adaptiveText(bool isDark)    => isDark ? textInverse : textPrimary;
}

/// Bridge to keep legacy [ColorUtils] in sync if needed.
extension ColorUtilsBridge on ColorUtils {
  static LinearGradient get brandGradient => ColorUtils.tealGradient;
}

