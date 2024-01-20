import 'package:coinxfiat/constants/constants_index.dart';
import 'package:coinxfiat/utils/my_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_multiselect/flutter_simple_multiselect.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:nb_utils/nb_utils.dart';

class MultiSelectField extends StatefulWidget {
  const MultiSelectField({
    super.key,
    this.onChanged,
    required this.onRequest,
    required this.hintText,
    this.titleText,
    this.toolTipText,
    this.toolTipIconColor,
    this.toolTipBgColor,
    this.initialValue = const {},
    required this.initialItems,
    this.validator,
    this.leadingBuilder,
    this.trailingBuilder,
  });
  final void Function(List<Map<String, dynamic>> list)? onChanged;
  final Future<List<Map<String, dynamic>>> Function(String) onRequest;
  final String hintText;
  final String? titleText;
  final String? toolTipText;
  final Color? toolTipIconColor;
  final Color? toolTipBgColor;
  final Map<String, dynamic> initialValue;
  final List<Map<String, dynamic>> initialItems;
  final String? Function(dynamic, List<dynamic> selectedItemsAsync)? validator;
  final Widget Function(BuildContext, dynamic, dynamic, bool)? leadingBuilder;
  final Widget? Function(BuildContext, dynamic, dynamic, bool)? trailingBuilder;

  @override
  State<MultiSelectField> createState() => _MultiSelectFieldState();
}

class _MultiSelectFieldState extends State<MultiSelectField> {
  late Color lineColor = const Color.fromRGBO(36, 37, 51, 0.04);
  List<Map<String, dynamic>> selectedItemsAsync = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _asyncData();
  }

  Widget _asyncData() {
    InputDecorationTheme theme = Theme.of(context).inputDecorationTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.titleText != null)
          Wrap(
            children: [
              Text(widget.titleText!, style: boldTextStyle(), maxLines: 2),
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
              // Tooltip(
              //   decoration: BoxDecoration(
              //     color: widget.toolTipBgColor ?? Colors.black,
              //     borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
              //   ),
              //   triggerMode: TooltipTriggerMode.tap,
              //   padding: const EdgeInsets.all(DEFAULT_PADDING),
              //   margin: const EdgeInsetsDirectional.symmetric(
              //       horizontal: DEFAULT_PADDING),
              //   message: widget.toolTipText ?? '',
              //   child: Container(
              //     padding: const EdgeInsetsDirectional.all(5),
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: widget.toolTipIconColor ?? Colors.grey.shade200,
              //     ),
              //     child: const FaIcon(FontAwesomeIcons.question,
              //         color: Colors.grey, size: 10),
              //   ),
              // ),
            ],
          ).paddingBottom(10),
        LayoutBuilder(builder: (context, constraints) {
          return FlutterMultiselect(
              autofocus: false,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              enableBorderColor: theme.enabledBorder?.borderSide.color,
              focusedBorderColor: theme.focusedBorder?.borderSide.color,
              borderRadius: DEFAULT_RADIUS,
              suggestionsBoxRadius: DEFAULT_RADIUS,
              borderSize: 1,
              resetTextOnSubmitted: true,
              suggestionsBoxElevation: 10,
              suggestionsBoxMaxHeight: 300,
              length: selectedItemsAsync.length,
              isLoading: isLoading,
              // readOnly: true,
              minTextFieldWidth: constraints.maxWidth,
              inputDecoration: InputDecoration(
                hintText: widget.hintText,
                // hintStyle: secondaryTextStyle(),
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: lineColor)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: lineColor)),
              ),
              validator: widget.validator != null
                  ? (e) => widget.validator!(e, selectedItemsAsync)
                  : (value) {
                      if (selectedItemsAsync.length < 2) {
                        return "min 2 items required";
                      }
                      return null;
                    },
              tagBuilder: (context, index) => SelectTag(
                    index: index,
                    label: selectedItemsAsync[index]["name"],
                    onDeleted: (value) {
                      selectedItemsAsync.removeAt(index);
                      setState(() {});
                    },
                  ),
              suggestionBuilder: (context, state, data) {
                var existingIndex = selectedItemsAsync
                    .indexWhere((element) => element["uuid"] == data["uuid"]);
                var selectedData = data;
                return Material(
                    child: ListTile(
                        leading: widget.leadingBuilder
                            ?.call(context, state, data, existingIndex >= 0),
                        selected: existingIndex >= 0,
                        trailing: widget.trailingBuilder != null
                            ? widget.trailingBuilder!
                                .call(context, state, data, existingIndex >= 0)
                            : existingIndex >= 0
                                ? const Icon(Icons.check_circle_outline_rounded)
                                : null,
                        // selectedColor: Colors.white,
                        // selectedTileColor: context.accentColor.withOpacity(0.2),
                        title: Text(selectedData["name"].toString()),
                        onTap: () {
                          var existingIndex = selectedItemsAsync.indexWhere(
                              (element) => element["uuid"] == data["uuid"]);
                          if (existingIndex >= 0) {
                            selectedItemsAsync.removeAt(existingIndex);
                          } else {
                            selectedItemsAsync.add(data);
                          }
                          state.selectAndClose(data);
                          widget.onChanged?.call(selectedItemsAsync);
                          setState(() {});
                        }));
              },
              findSuggestions: (String query) async {
                setState(() => isLoading = true);
                var data = await widget.onRequest(query);
                setState(() => isLoading = false);
                return data;
              });
        }),
      ],
    );
  }
}

class SelectTag extends StatelessWidget {
  const SelectTag({
    super.key,
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;
  final Color darkAlias6 = const Color.fromRGBO(36, 37, 51, 0.06);

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: darkAlias6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
