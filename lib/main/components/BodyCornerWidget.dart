import 'package:flutter/material.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../main.dart';
import '../utils/dynamic_theme.dart';

class BodyCornerWidget extends StatelessWidget {
  final Widget child;
  final Color? color;

  BodyCornerWidget({required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: appStore.isDarkMode
            ? ColorUtils.tealGradient
            : LinearGradient(colors: [ColorUtils.colorPrimary, ColorUtils.colorPrimary]),
      ),
      child: Container(
        color: appStore.isDarkMode ? ColorUtils.scaffoldColorDark : ColorUtils.colorPrimaryLight,
        height: context.height(),
        width: context.width(),
        child: child,
      ).cornerRadiusWithClipRRectOnly(topRight: 24, topLeft: 24),
    );
  }
}
