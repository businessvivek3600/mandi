import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FilterChipItem extends StatelessWidget {
  const FilterChipItem({
    super.key,
    required this.tag,
    required this.label,
    this.subtitle,
    this.icon,
    this.color,
    this.textColor,
    this.onTap,
    this.onClear,
    this.trailing,
  });
  final String tag;
  final Widget label;
  final String? subtitle;
  final Widget? icon;
  final Color? color;
  final Color? textColor;
  final void Function()? onTap;
  final void Function(String tag)? onClear;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Chip(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        avatar: icon ?? const SizedBox(),
        label: label,
        backgroundColor: color ?? context.accentColor.withOpacity(0.5),
        onDeleted: () => onClear?.call(tag),
        deleteIcon: trailing ??
            const Icon(CupertinoIcons.clear_circled_solid,
                size: 20, color: Colors.white),
        deleteIconColor: Colors.white,
      ),
    ).onTap(onTap);
  }
}
