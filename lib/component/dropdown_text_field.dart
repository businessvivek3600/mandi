import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constants/constants_index.dart';
import '../widgets/widget_index.dart';

class SearchRequestDropdown extends StatelessWidget {
  const SearchRequestDropdown({
    Key? key,
    this.onChanged,
    required this.onRequest,
    required this.hintText,
    required this.initialItems,
    this.titleText,
    this.toolTipText,
    this.toolTipIconColor,
    this.toolTipBgColor,
    this.initialValue,
    this.sideWidget,
    this.validator,
  }) : super(key: key);
  final void Function(Pair?)? onChanged;
  final Future<List<Pair>> Function(String) onRequest;
  final String hintText;
  final String? titleText;
  final String? toolTipText;
  final Color? toolTipIconColor;
  final Color? toolTipBgColor;
  final Pair? initialValue;
  final List<Pair> initialItems;
  final Widget? sideWidget;
  final String? Function(Pair?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (titleText != null)
          Row(
            children: [
              Text(titleText!, style: boldTextStyle()),
              10.width,
              if (toolTipText != null)
                JustTheTooltip(
                  content: Padding(
                    padding: const EdgeInsets.all(DEFAULT_PADDING),
                    child: Text(toolTipText!, style: primaryTextStyle()),
                  ),
                  triggerMode: TooltipTriggerMode.tap,
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: toolTipIconColor ?? Colors.grey.shade200,
                    ),
                    child: const FaIcon(FontAwesomeIcons.question,
                        color: Colors.grey, size: 10),
                  ),
                ),
              /*
                Tooltip(
                  decoration: BoxDecoration(
                    color: toolTipBgColor ??
                        const Color.fromARGB(255, 233, 231, 231),
                    borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  triggerMode: TooltipTriggerMode.tap,
                  padding: const EdgeInsets.all(DEFAULT_PADDING),
                  margin: const EdgeInsetsDirectional.symmetric(
                      horizontal: DEFAULT_PADDING),
                  message: toolTipText ?? '',
                  textStyle: primaryTextStyle(),
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: toolTipIconColor ?? Colors.grey.shade200,
                    ),
                    child: const FaIcon(FontAwesomeIcons.question,
                        color: Colors.grey, size: 10),
                  ),
                  //
                ),
            
            */
            ],
          ).paddingBottom(10),
        Row(
          children: [
            Expanded(
              child: CustomDropdown<Pair>.searchRequest(
                futureRequest: onRequest,
                hintText: hintText,
                items: initialItems,
                initialItem: initialValue,
                validator: validator,
                onChanged: (value) => onChanged?.call(value),
                headerBuilder: (context, value) => Text(value.text,
                    style: boldTextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color)),
                listItemBuilder: (context, value) => Text(value.text,
                    style: boldTextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color)),
                closedBorder: Border.all(color: Colors.grey.shade300),
              ),
            ),
            if (sideWidget != null) sideWidget!.paddingLeft(10),
          ],
        ),
      ],
    );
  }
}

class MyDropdown extends StatelessWidget {
  const MyDropdown({
    Key? key,
    this.onChanged,
    required this.hintText,
    required this.initialItems,
    this.titleText,
    this.toolTipText,
    this.toolTipIconColor,
    this.toolTipBgColor,
    this.initialValue,
    this.sideWidget,
    this.validator,
  }) : super(key: key);
  final void Function(Pair?)? onChanged;
  final String hintText;
  final String? titleText;
  final String? toolTipText;
  final Color? toolTipIconColor;
  final Color? toolTipBgColor;
  final Pair? initialValue;
  final List<Pair> initialItems;
  final Widget? sideWidget;
  final String? Function(Pair?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (titleText != null)
          Row(
            children: [
              Text(titleText!, style: boldTextStyle()),
              10.width,
              if (toolTipText != null && toolTipText!.isNotEmpty)
                JustTheTooltip(
                  content: Padding(
                    padding: const EdgeInsets.all(DEFAULT_PADDING),
                    child: Text(toolTipText!, style: primaryTextStyle()),
                  ),
                  triggerMode: TooltipTriggerMode.tap,
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: toolTipIconColor ?? Colors.grey.shade200,
                    ),
                    child: const FaIcon(FontAwesomeIcons.question,
                        color: Colors.grey, size: 10),
                  ),
                ),
            ],
          ).paddingBottom(10),
        Row(
          children: [
            Expanded(
              child: CustomDropdown<Pair>(
                hintText: hintText,
                items: initialItems.isEmpty
                    ? [Pair(key: null, text: 'No Data')]
                    : initialItems,
                initialItem: initialValue,
                validator: validator,
                onChanged: (value) => onChanged?.call(value),
                headerBuilder: (context, value) => Text(value.text,
                    style: boldTextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color)),
                listItemBuilder: (context, value) => Text(value.text,
                        style: boldTextStyle(
                            color:
                                Theme.of(context).textTheme.bodySmall?.color))
                    .onTap(
                  value.key != null ? null : () {},
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                closedBorder:
                    Border.all(color: Colors.grey.shade300, width: 1.5),
              ),
            ),
            if (sideWidget != null) sideWidget!.paddingLeft(10),
          ],
        ),
      ],
    );
  }
}

class Pair {
  Pair({required this.key, required this.text, this.icon, this.enabled = true});
  final dynamic key;
  final String text;
  final IconData? icon;
  final bool enabled;

  Pair fromJson(Map<String, dynamic> json) {
    return Pair(
        key: json['key'],
        text: json['text'],
        icon: json['icon'],
        enabled: json['enabled'] ?? true);
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'text': text,
      'icon': icon,
      'enabled': enabled,
    };
  }
}
