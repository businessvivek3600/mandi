import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constants/constants_index.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.onChanged,
    required this.hintText,
    this.titleText,
    this.toolTipText,
    this.toolTipIconColor,
    this.toolTipBgColor,
    this.readOnly = false,
    this.initialValue = '',
    this.keyboardType,
    this.inputFormatters = const [],
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.controller,
    this.enabled = true,
    this.validator,
  }) : super(key: key);
  final void Function(String?)? onChanged;
  final String hintText;
  final String? titleText;
  final String? toolTipText;
  final Color? toolTipIconColor;
  final Color? toolTipBgColor;
  final bool readOnly;
  final String initialValue;
  final TextInputType? keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int maxLines;
  final TextInputAction textInputAction;
  final TextEditingController? controller;
  final bool enabled;
  final String? Function(String?)? validator;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.titleText != null)
          Row(
            children: [
              Text(widget.titleText!, style: boldTextStyle()),
              10.width,
              if (widget.toolTipText != null)
                JustTheTooltip(
                  content: Padding(
                    padding: const EdgeInsets.all(DEFAULT_PADDING),
                    child: Text(widget.toolTipText!, style: primaryTextStyle()),
                  ),
                  triggerMode: TooltipTriggerMode.tap,
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.toolTipIconColor ?? Colors.grey.shade200,
                    ),
                    child: const FaIcon(FontAwesomeIcons.question,
                        color: Colors.grey, size: 10),
                  ),
                ),
            ],
          ).paddingBottom(10),
        TextFormField(
          controller: controller,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          onChanged: widget.onChanged,
          inputFormatters: widget.inputFormatters,
          onTap: () async {},
          validator: (s) => widget.validator?.call(s),
          decoration: InputDecoration(
            filled: !widget.enabled,
            fillColor: Colors.grey.shade100,
            counterText: '',
            hintText: widget.hintText,
            hintStyle: secondaryTextStyle(),
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
          ),
        ).paddingBottom(10),
      ],
    );
  }
}
