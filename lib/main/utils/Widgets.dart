import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../main/utils/dynamic_theme.dart';

import '../../extensions/decorations.dart';
import '../../extensions/text_styles.dart';
import '../../main.dart';
import 'Constants.dart';

Widget commonButton(String title, Function() onTap, {double? width, Color? color, Color? textColor, int? size}) {
  return SizedBox(
    width: width,
    child: Container(
      height: 48,
      decoration: BoxDecoration(
        gradient: color != null
            ? null
            : ColorUtils.tealGradient,
        color: color,
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(defaultRadius),
          onTap: onTap,
          child: Center(
            child: Text(
              title,
              style: boldTextStyle(color: textColor ?? Colors.white, size: size ?? textBoldSizeGlobal.toInt()),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget outlineButton(String title, Function() onTap, {double? width, Color? color}) {
  return SizedBox(
    width: width,
    child: TextButton(
      child: Text(title, style: boldTextStyle(color: color ?? ColorUtils.colorPrimary)),
      onPressed: onTap,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultRadius),
            side: BorderSide(color: color ?? ColorUtils.colorPrimary)),
        elevation: 0,
        padding: .symmetric(vertical: 14, horizontal: 16),
        backgroundColor: Colors.transparent,
      ),
    ),
  );
}

Widget scheduleOptionWidget(BuildContext context, bool isSelected, String imagePath, String title) {
  return Container(
    padding: .all(16),
    alignment: Alignment.center,
    decoration: isSelected
        ? BoxDecoration(
            gradient: ColorUtils.tealGradient,
            borderRadius: BorderRadius.circular(defaultRadius),
          )
        : boxDecorationWithRoundedCorners(
            border: Border.all(color: appStore.isDarkMode ? ColorUtils.dividerColor : ColorUtils.borderColor),
            backgroundColor: context.cardColor),
    child: Row(
      crossAxisAlignment: .center,
      mainAxisAlignment: .center,
      children: [
        Icon(title == language.schedule ? Feather.calendar : Feather.clock,
            size: 18, color: isSelected ? Colors.white : context.iconColor),
        8.width,
        Text(title, style: boldTextStyle(color: isSelected ? Colors.white : textPrimaryColorGlobal)),
      ],
    ),
  );
}

Widget enableBidOptionWidget(BuildContext context, bool isSelected, IconData icon, String title) {
  return Container(
    padding: .all(16),
    alignment: Alignment.center,
    decoration: isSelected
        ? BoxDecoration(
            gradient: ColorUtils.tealGradient,
            borderRadius: BorderRadius.circular(defaultRadius),
          )
        : boxDecorationWithRoundedCorners(
            border: Border.all(color: appStore.isDarkMode ? ColorUtils.dividerColor : ColorUtils.borderColor),
            backgroundColor: context.cardColor),
    child: Row(
      crossAxisAlignment: .center,
      mainAxisAlignment: .center,
      children: [
        Icon(icon, color: isSelected ? Colors.white : context.iconColor),
        8.width,
        Text(title, style: boldTextStyle(color: isSelected ? Colors.white : textPrimaryColorGlobal)),
      ],
    ),
  );
}

/// Default AppBar — dégradé teal→bleu en dark, couleur primary en light
AppBar commonAppBarWidget(
  String title, {
  @Deprecated('Use titleWidget instead') Widget? child,
  Widget? titleWidget,
  List<Widget>? actions,
  Color? color,
  bool center = false,
  Color? textColor,
  int textSize = 18,
  double titleSpacing = 2,
  bool showBack = true,
  bool isBottom = true,
  Color? shadowColor,
  double? elevation,
  Widget? backWidget,
  @Deprecated('Use systemOverlayStyle instead') Brightness? brightness,
  SystemUiOverlayStyle? systemUiOverlayStyle,
  TextStyle? titleTextStyle,
  PreferredSizeWidget? bottom,
  Widget? flexibleSpace,
}) {
  final bool useTealGradient = color == null && flexibleSpace == null;

  final Widget? resolvedFlexibleSpace = flexibleSpace ??
      (useTealGradient
          ? Container(
              decoration: BoxDecoration(
                gradient: ColorUtils.tealGradient,
              ),
            )
          : null);

  return AppBar(
    centerTitle: center,
    title: titleWidget ??
        Text(title,
            style: titleTextStyle ?? boldTextStyle(color: textColor ?? Colors.white, size: textSize)),
    actions: actions ?? [],
    automaticallyImplyLeading: showBack,
    backgroundColor: resolvedFlexibleSpace != null
        ? Colors.transparent
        : (color ?? ColorUtils.colorPrimary),
    leading: showBack ? (backWidget ?? BackButton(color: textColor ?? Colors.white)) : null,
    shadowColor: shadowColor,
    shape: isBottom
        ? RoundedRectangleBorder(borderRadius: radiusOnly(bottomRight: 20, bottomLeft: 20))
        : null,
    elevation: elevation ?? defaultAppBarElevation,
    systemOverlayStyle: systemUiOverlayStyle,
    bottom: bottom,
    titleSpacing: showBack ? titleSpacing : 20,
    flexibleSpace: resolvedFlexibleSpace,
  );
}
