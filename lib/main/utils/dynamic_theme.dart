import 'package:flutter/material.dart';

class ColorUtils {
  static Color? themeColor;
  static Color? _colorPrimary;
  static Color? _colorPrimaryLight;
  static Color? _borderColor;
  static Color? _bottomNavigationColor;
  static Color? _scaffoldSecondaryDark;
  static Color? _scaffoldColorDark;
  static Color? _scaffoldColorLight;
  static Color? _appButtonColorDark;
  static Color? _dividerColor;
  static Color? _cardDarkColor;

  // ── Veloxi AFTER palette ──────────────────────────────
  // primary teal accent
  static const String veloxiPrimaryHex = "FF12C7B0";
  static const Color veloxiTeal     = Color(0xFF12C7B0);
  static const Color veloxiBlue     = Color(0xFF0088FF);
  // navy backgrounds
  static const Color navyDeep       = Color(0xFF0F172A); // slate-900
  static const Color navySurface    = Color(0xFF1E293B); // slate-800
  static const Color navyCard       = Color(0xFF1E293B); // slate-800
  static const Color navyBorder     = Color(0xFF334155); // slate-700
  // gradient stops (AppBar / boutons)
  static const LinearGradient tealGradient = LinearGradient(
    colors: [veloxiTeal, veloxiBlue],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  // ─────────────────────────────────────────────────────

  ColorUtils({String primaryHex = veloxiPrimaryHex}) {
    themeColor = colorFromHex(primaryHex);
    _colorPrimary = colorFromHex(primaryHex);
    _initializeColors();
  }

  _initializeColors() async {
    _colorPrimaryLight = const Color(0xFFF0FDFB);
    _borderColor       = const Color(0xFFD1FAF4);
    _scaffoldSecondaryDark = navySurface;
    _scaffoldColorDark     = navyDeep;
    _scaffoldColorLight    = Colors.white;
    _appButtonColorDark    = navyCard;
    _dividerColor          = navyBorder;
    _cardDarkColor         = navyCard;
    _bottomNavigationColor = const Color(0xFF0F1923);
  }

  static void updateColors(String color) {
    themeColor    = colorFromHex(color);
    _colorPrimary = colorFromHex(color);
    _colorPrimaryLight     = const Color(0xFFF0FDFB);
    _borderColor           = const Color(0xFFD1FAF4);
    _scaffoldSecondaryDark = navySurface;
    _scaffoldColorDark     = navyDeep;
    _scaffoldColorLight    = Colors.white;
    _appButtonColorDark    = navyCard;
    _dividerColor          = navyBorder;
    _cardDarkColor         = navyCard;
    _bottomNavigationColor = navySurface;
  }

  static Color colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) hexColor = 'FF$hexColor';
    _colorPrimary = Color(int.parse(hexColor, radix: 16));
    return Color(int.parse(hexColor, radix: 16));
  }

  static Color bottomNavigationBarColor(String color) {
    return navySurface;
  }

  static Color lightenColor(Color color, double percent) {
    final p = percent / 100;
    final r = ((color.r * 255.0).round().clamp(0, 255) + ((255 - (color.r * 255.0).round().clamp(0, 255)) * p)).round();
    final g = ((color.g * 255.0).round().clamp(0, 255) + ((255 - (color.g * 255.0).round().clamp(0, 255)) * p)).round();
    final b = ((color.b * 255.0).round().clamp(0, 255) + ((255 - (color.b * 255.0).round().clamp(0, 255)) * p)).round();
    return Color.fromRGBO(r, g, b, 1.0);
  }

  static Color get colorPrimary          => _colorPrimary          ?? veloxiTeal;
  static Color get colorPrimaryLight     => _colorPrimaryLight     ?? const Color(0xFFF0FDFB);
  static Color get borderColor           => _borderColor           ?? const Color(0xFFD1FAF4);
  static Color get bottomNavigationColor => _bottomNavigationColor ?? navySurface;
  static Color get scaffoldSecondaryDark => _scaffoldSecondaryDark ?? navySurface;
  static Color get scaffoldColorDark     => _scaffoldColorDark     ?? navyDeep;
  static Color get scaffoldColorLight    => _scaffoldColorLight    ?? Colors.white;
  static Color get appButtonColorDark    => _appButtonColorDark    ?? navyCard;
  static Color get dividerColor          => _dividerColor          ?? navyBorder;
  static Color get cardDarkColor         => _cardDarkColor         ?? navyCard;
}
