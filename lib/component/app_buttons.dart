// import 'package:flutter/material.dart';
// import 'package:nb_utils/nb_utils.dart';

// ///create button with alldynamic properties like,borderradius, color, text, icon, border, bordercolor, splash color,shadow color, elevation, hover effect or touch enter effect like sound,vibration, animation, scale in

// class AppButton extends StatelessWidget {
//   const AppButton({
//     Key? key,
//     this.onPressed,
//     this.text,
//     this.icon,
//     this.color,
//     this.textColor,
//     this.splashColor,
//     this.border,
//     this.borderColor,
//     this.borderRadius,
//     this.shadowColor,
//     this.elevation,
//     this.hoverColor,
//     this.hoverElevation,
//     this.hoverShadowColor,
//   }) : super(key: key);
//   final VoidCallback? onPressed;
//   final String? text;
//   final IconData? icon;
//   final Color? color;
//   final Color? textColor;
//   final Color? splashColor;
//   final Border? border;
//   final Color? borderColor;
//   final BorderRadius? borderRadius;
//   final Color? shadowColor;
//   final double? elevation;
//   final Color? hoverColor;
//   final double? hoverElevation;
//   final Color? hoverShadowColor;

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color ?? context.primaryColor,
//         foregroundColor: textColor ??
//             (context.theme.brightness == Brightness.light
//                 ? Colors.white
//                 : Colors.black),
//         shadowColor: shadowColor ?? context.primaryColor.withOpacity(0.5),
//         elevation: elevation ?? 0,
//         padding: const EdgeInsets.all(0),
//         shape: RoundedRectangleBorder(
//           borderRadius: borderRadius ?? BorderRadius.circular(defaultRadius),
//           // side: border ?? BorderSide.none,
//         ),
//         animationDuration: const Duration(milliseconds: 300),
//         splashFactory: InkRipple.splashFactory,
//         // overlayColor: MaterialStateProperty.all(
//         //   hoverColor ?? context.primaryColor.withOpacity(0.2),
//         // ),
//         visualDensity: VisualDensity.compact,
//         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (icon != null) Icon(icon),
//             if (icon != null && text != null) 8.width,
//             if (text != null) Text(text!),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class DynamicButton extends StatefulWidget {
  double? borderRadius;
  Color? color;
  Color? textColor;
  final String? text;
  final IconData? icon;
  double? elevation;
  final dynamic Function()? onPressed;
  bool isOutline = false;

  DynamicButton({
    super.key,
    this.borderRadius,
    this.color,
    required this.text,
    this.icon,
    this.elevation,
    this.onPressed,
  });

  DynamicButton.outline({
    super.key,
    this.borderRadius,
    this.color,
    required this.text,
    this.icon,
    this.elevation,
    this.onPressed,
  }) {
    color = Colors.transparent;
    elevation ??= 0;
    isOutline = true;
  }

  @override
  _DynamicButtonState createState() => _DynamicButtonState();
}

class _DynamicButtonState extends State<DynamicButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    widget.borderRadius ??= 30;
    if (widget.isOutline) {
      widget.textColor ??= context.primaryColor;
    } else {
      widget.textColor ??= Colors.white;
    }
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
          _playHoverEffect();
        });
      },
      onExit: (_) => setState(() => isHovered = false),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.isOutline
              ? Colors.transparent
              : (isHovered ? widget.color!.withOpacity(0.8) : widget.color),
          elevation: widget.isOutline ? 0 : widget.elevation,
          shadowColor: widget.isOutline
              ? context.primaryColor.withOpacity(0.1)
              : (isHovered
                  ? context.primaryColor.withOpacity(0.5)
                  : widget.color),
          surfaceTintColor: widget.isOutline
              ? context.primaryColor
              : (isHovered
                  ? context.primaryColor.withOpacity(0.5)
                  : widget.color),
          splashFactory: InkRipple.splashFactory,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius!),
            side: widget.isOutline
                ? BorderSide(color: widget.textColor!)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon).visible(widget.icon != null),
            const SizedBox(width: 8).visible(widget.icon != null),
            if (widget.text != null)
              Text(widget.text!, style: boldTextStyle(color: widget.textColor)),
          ],
        ),
      ),
    );
  }

  void _playHoverEffect() async {
    // You can customize this method to add more effects
    HapticFeedback.vibrate();
    // You can add more hover effects here like sound, animation, etc.
  }
}
