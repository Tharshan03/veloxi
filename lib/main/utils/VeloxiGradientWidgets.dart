import 'package:flutter/material.dart';

import 'dynamic_theme.dart';

// ── Gradients ────────────────────────────────────────────────────────────────
LinearGradient get veloxiPrimaryGradient => ColorUtils.tealGradient;

// ── Gradient Button ──────────────────────────────────────────────────────────
class VeloxiGradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const VeloxiGradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: ColorUtils.tealGradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          padding: padding,
        ),
        child: child,
      ),
    );
  }
}

// ── Gradient AppBar ──────────────────────────────────────────────────────────
class VeloxiGradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const VeloxiGradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
          decoration: BoxDecoration(gradient: ColorUtils.tealGradient)),
    );
  }
}

// ── Dark Card ────────────────────────────────────────────────────────────────
class VeloxiGradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double radius;

  const VeloxiGradientCard({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(16),
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: ColorUtils.cardDarkColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: ColorUtils.dividerColor),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

// ── Badge ────────────────────────────────────────────────────────────────────
class VeloxiBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final Color textColor;

  const VeloxiBadge({
    super.key,
    required this.label,
    this.color,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: color == null ? ColorUtils.tealGradient : null,
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label,
          style: TextStyle(
              color: textColor, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

// ── Gradient FAB ─────────────────────────────────────────────────────────────
class VeloxiGradientFab extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final String? heroTag;

  const VeloxiGradientFab({
    super.key,
    required this.onPressed,
    required this.child,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      elevation: 0,
      backgroundColor: Colors.transparent,
      onPressed: onPressed,
      child: Ink(
        decoration: BoxDecoration(
            shape: BoxShape.circle, gradient: ColorUtils.tealGradient),
        child: SizedBox.square(dimension: 56, child: Center(child: child)),
      ),
    );
  }
}

// ── Gradient Text ────────────────────────────────────────────────────────────
class VeloxiGradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const VeloxiGradientText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    final base =
        style ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    return ShaderMask(
      shaderCallback: (Rect bounds) =>
          ColorUtils.tealGradient.createShader(bounds),
      child: Text(text, style: base.copyWith(color: Colors.white)),
    );
  }
}
