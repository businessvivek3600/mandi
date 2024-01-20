import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constants/constants_index.dart';

class ShadowedDialog extends StatelessWidget {
  const ShadowedDialog(
      {super.key,
      required this.title,
      this.content,
      this.actions,
      this.bgColor,
      this.seperatorColor,
      this.confirmText,
      this.cancelText,
      this.onConfirm,
      this.onCancel,
      this.message});
  final String title;
  final String? message;
  final Widget? content;
  final Widget? actions;
  final Color? bgColor;
  final Color? seperatorColor;
  final String? confirmText;
  final String? cancelText;
  final Future<dynamic> Function()? onConfirm;
  final Future<dynamic> Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DEFAULT_PADDING / 2)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(),
          _buildChild(context,
                  bgColor: bgColor ??
                      context.scaffoldBackgroundColor.withOpacity(0.7),
                  back: true)
              .center(),
          _buildChild(context,
                  bgColor: bgColor ?? context.scaffoldBackgroundColor)
              .center(),
        ],
      ),
    );
  }

  Widget _buildChild(BuildContext context,
      {Color? bgColor, bool back = false}) {
    return Container(
      margin: EdgeInsets.only(
        top: back ? 0 : DEFAULT_PADDING,
        right: !back ? 0 : DEFAULT_PADDING,
        left: back ? 0 : DEFAULT_PADDING,
        bottom: !back ? 0 : DEFAULT_PADDING,
      ),
      padding: const EdgeInsets.all(DEFAULT_PADDING),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(DEFAULT_PADDING / 4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w700, color: context.primaryColor),
          ),
          Divider(color: seperatorColor ?? Colors.grey, height: 24.0),
          content ??
              Text(message ?? 'Are you sure you want to logout?',
                  style: primaryTextStyle()),
          50.height,
          actions ??
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.primaryColor,
                        side: BorderSide(
                            color: context.primaryColor.withOpacity(0.2),
                            width: 2),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(DEFAULT_RADIUS * 3)),
                      ),
                      onPressed: () async {
                        if (onCancel != null) {
                          await onCancel!().then((value) => context.pop());
                        } else {
                          context.pop();
                        }
                      },
                      child: Text(cancelText ?? 'Cancel'),
                    ),
                  ),
                  20.width,
                  SizedBox(
                    height: 30,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: context.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(DEFAULT_RADIUS * 3)),
                      ),
                      onPressed: () async {
                        if (onConfirm != null) {
                          await onConfirm!();
                        }
                      },
                      child: Text(confirmText ?? 'Logout'),
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
