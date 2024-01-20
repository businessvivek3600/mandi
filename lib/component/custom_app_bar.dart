// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'component_index.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  bool? centerTitle;
  final double? elevation;
  final Color? shadowColor;
  final Color? backgroundColor;
  final Brightness? brightness;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final TextTheme? textTheme;
  final bool primary;
  final double? toolbarOpacity;
  final double? bottomOpacity;
  final double? toolbarHeight;
  final double? leadingWidth;
  final bool? backwardsCompatibility;
  final PreferredSizeWidget? bottom;
  final ShapeBorder? shape;
  final bool? automaticallyImplyLeading;
  final double? titleSpacing;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final double? toolbarBorderRadius;
  final double? toolbarElevation;
  final Widget? leading;
  final bool? excludeHeaderSemantics;

  GradientAppBar(
      {super.key,
      required this.title,
      this.actions,
      this.centerTitle,
      this.elevation = 0.0,
      this.shadowColor = Colors.transparent,
      this.backgroundColor = Colors.transparent,
      this.brightness,
      this.iconTheme,
      this.actionsIconTheme,
      this.textTheme,
      this.primary = true,
      this.toolbarOpacity,
      this.bottomOpacity,
      this.toolbarHeight,
      this.leadingWidth,
      this.backwardsCompatibility,
      this.bottom,
      this.shape,
      this.automaticallyImplyLeading = true,
      this.titleSpacing,
      this.toolbarTextStyle,
      this.titleTextStyle,
      this.systemOverlayStyle,
      this.toolbarBorderRadius,
      this.toolbarElevation,
      this.leading,
      this.excludeHeaderSemantics});

  @override
  Widget build(BuildContext context) {
    centerTitle ??= Platform.isIOS;
    return AppBar(
      title: title,
      actions: actions,
      centerTitle: centerTitle,
      elevation: elevation,
      shadowColor: shadowColor,
      backgroundColor: backgroundColor,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      primary: primary,
      toolbarOpacity: toolbarOpacity ?? 1.0,
      bottomOpacity: bottomOpacity ?? 1.0,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      bottom: bottom,
      shape: shape,
      automaticallyImplyLeading: automaticallyImplyLeading!,
      titleSpacing: titleSpacing,
      toolbarTextStyle: toolbarTextStyle,
      titleTextStyle: titleTextStyle,
      systemOverlayStyle: systemOverlayStyle,
      leading: leading,
      excludeHeaderSemantics: excludeHeaderSemantics ?? false,
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: appBarGradient(context)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
