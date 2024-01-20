import 'package:coinxfiat/component/custom_app_bar.dart';
import 'package:coinxfiat/utils/utils_index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constants/constants_index.dart';
import '../store/store_index.dart';

class BottomSheetFilter extends StatefulWidget {
  const BottomSheetFilter({
    super.key,
    this.topRadius = DEFAULT_RADIUS,
    this.topPadding = kToolbarHeight,
    this.onApplyFilter,
    this.onClearFilter,
    this.onResetFilter,
    this.title = 'Filter',
    this.subTitle,
    this.showCloseIcon = true,
    required this.filterItem,
    required this.filterData,
    this.launchFrom,
  });
  final double topRadius;
  final double topPadding;
  final Future<void> Function(bool, Map<FilterItem, dynamic> data)?
      onApplyFilter;
  final Future<void> Function(bool, Map<FilterItem, dynamic> data)?
      onClearFilter;
  final Future<void> Function(bool, Map<FilterItem, dynamic> data)?
      onResetFilter;
  final String title;
  final String? subTitle;
  final String? launchFrom;
  final bool showCloseIcon;
  final List<FilterItem> filterItem;
  final List<FilterData> filterData;

  @override
  State<BottomSheetFilter> createState() => _BottomSheetFilterState();
}

class _BottomSheetFilterState extends State<BottomSheetFilter> {
  Map<FilterItem, dynamic> filterMap = {};
  String selectedKey = '';

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      initFilter();
    });
  }

  setValue(FilterItem filterItem, dynamic val) async {
    filterItem.initialValue = val;
    print('filterItem.initialValue: ${filterItem.initialValue.runtimeType}');
    setState(() {});
  }

  initFilter() {
    for (var item in widget.filterItem) {
      if (widget.filterData.any((element) => element.tag == item.tag)) {
        filterMap.putIfAbsent(item,
            () => widget.filterData.firstWhere((data) => data.tag == item.tag));
      }
    }
    if (filterMap.isNotEmpty) {
      selectedKey = widget.launchFrom ?? filterMap.entries.first.key.tag;
    }
    setState(() {});
  }

  clearFilter() {
    for (var element in filterMap.entries) {
      element.key.initialValue = null;
    }
    setState(() {});
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(DEFAULT_RADIUS),
        topRight: Radius.circular(DEFAULT_RADIUS),
      ),
      child: Scaffold(
        appBar: _appBar(context),
        body: Row(
          children: [
            Expanded(flex: 2, child: _buildLeft(context)),
            Expanded(
                flex: 3,
                child: _buildRight(
                    context,
                    selectedKey.isEmpty
                        ? null
                        : filterMap.entries
                            .firstWhere(
                                (element) => element.key.tag == selectedKey)
                            .value)),
          ],
        ),
        bottomNavigationBar: _buildBottom(context),
      ),
    ).paddingOnly(top: widget.topPadding);
  }

  Widget _buildRight(BuildContext context, dynamic data) {
    return data == null ? Container() : getChild(data);
  }

  Widget getChild(dynamic data) {
    final filterItem = filterMap.entries
        .firstWhere((element) => element.key.tag == data.tag)
        .key;
    if (data is FilterDataQuery) {
      return _getQueryWidget(filterItem, data).paddingAll(DEFAULT_PADDING);
    } else if (data is FilterDataRadio) {
      return _getRadioWidget(filterItem, data).paddingAll(DEFAULT_PADDING);
    } else if (data is FilterDataMultiChoice) {
      return const SizedBox();
    } else if (data is FilterDataDropdown) {
      return const SizedBox();
    } else if (data is FilterDateData) {
      return _getDateWidget(filterItem, data).paddingAll(DEFAULT_PADDING);
    } else {
      return const SizedBox();
    }
  }

  ///_getRadioWidget [FilterDataRadio] data to show radio filter widget
  Widget _getRadioWidget(FilterItem filterItem, FilterDataRadio data) {
    FilterDataRadioItem? selectedItem;
    if (filterItem.initialValue != null &&
        data.value
            .any((element) => element.key == filterItem.initialValue.key)) {
      selectedItem = data.value
          .firstWhere((element) => element.key == filterItem.initialValue.key);
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.value.length,
            itemBuilder: (_, index) {
              return RadioListTile<dynamic>(
                controlAffinity: ListTileControlAffinity.platform,
                contentPadding: EdgeInsets.zero,
                value: data.value[index],
                groupValue: selectedItem,
                onChanged: (val) async => setValue(filterItem, val),
                title: bodyMedText(data.value[index].label, context),
              );
            },
          ),
        ),
      ],
    );
  }

  ///_getDateWidget [FilterDateData] data to show date filter widget
  _DateFilter _getDateWidget(FilterItem filterItem, FilterDateData data) {
    DateTime? value;
    if (filterItem.initialValue != null) {
      value = DateTime.tryParse(filterItem.initialValue.toString());
    }
    data.value = value;
    return _DateFilter(
        key: ValueKey(filterItem.tag),
        data: [data],
        onClear: (DateTime? val) async => setValue(filterItem, null),
        onApply: (DateTime? value) async => setValue(filterItem, value));
  }

  ///_getQueryWidget [FilterDataQuery] data to show query filter widget
  Widget _getQueryWidget(FilterItem filterItem, FilterDataQuery data) {
    return _QueryFilter(
        key: ValueKey(filterItem.tag),
        controller: TextEditingController(text: filterItem.initialValue),
        hint: filterItem.label,
        onClear: (String? val) async => setValue(filterItem, ''),
        onApply: (String value) async => setValue(filterItem, value));
  }

  Widget _buildLeft(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: filterMap.entries
          .map((item) => _buildItem(context, item, filterMap[item]))
          .toList(),
    );
  }

  Widget _buildItem(BuildContext context, MapEntry<FilterItem, dynamic> entry,
      FilterData? filterData) {
    FilterItem item = entry.key;
    FilterData data = entry.value;
    return Hero(
      tag: item.tag,
      child: GestureDetector(
        onTap: () async {
          selectedKey = item.tag;
          setState(() => logger.f('selectedKey: $selectedKey'));
          if (item.type == FilterType.query) {
            // await _showQueryFilter(context, filterItem, filterData);
          } else if (item.type == FilterType.date) {
            // await _showDateFilter(context, filterItem, filterData);
          } else if (item.type == FilterType.multiChoice) {
            // await _showMultiChoiceFilter(context, filterItem, filterData);
          } else if (item.type == FilterType.radio) {
            // await _showRadioFilter(context, filterItem, filterData);
          } else if (item.type == FilterType.dropdown) {
            // await _showDropdownFilter(context, filterItem, filterData);
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: selectedKey == item.tag
                  ? Colors.grey.shade200
                  : Colors.transparent),
          padding: const EdgeInsets.all(DEFAULT_PADDING / 2),
          child: Row(
            children: [
              CircleAvatar(
                  backgroundColor: item.color,
                  // radius: DEFAULT_RADIUS,
                  maxRadius: DEFAULT_RADIUS * 1.5,
                  child:
                      item.icon.paddingAll(DEFAULT_PADDING / 2).center().fit()),
              width10(DEFAULT_PADDING / 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bodyMedText(item.label, context, maxLines: 1),
                    capText(item.subtitle, context,
                        maxLines: 1,
                        color: appStore.isDarkMode
                            ? Colors.white70
                            : Colors.grey.shade500),
                  ],
                ),
              ),
              width10(DEFAULT_PADDING / 2),
              const Icon(Icons.arrow_forward_ios, size: DEFAULT_RADIUS),
            ],
          ),
        ),
      ),
    );
  }

  GradientAppBar _appBar(BuildContext context) {
    return GradientAppBar(
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title),
          if (widget.subTitle != null)
            Text(
              widget.subTitle!,
              style: const TextStyle(fontSize: 12),
            ),
        ],
      ),
      actions: [
        if (widget.showCloseIcon)
          IconButton(
              onPressed: () async {
                if (widget.onResetFilter != null) {
                  await widget.onResetFilter!(true, filterMap)
                      .then((value) => Navigator.pop(context));
                }
              },
              icon: const Icon(Icons.refresh)),
      ],
    );
  }

  BottomAppBar _buildBottom(BuildContext context) {
    return BottomAppBar(
      elevation: 10,
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                if (widget.onApplyFilter != null) {
                  await widget.onApplyFilter!(true, filterMap)
                      .then((value) => Navigator.pop(context));
                }
              },
              child: const Text('Apply'),
            ),
          ),
          width20(DEFAULT_PADDING),
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red)),
              onPressed: () async {
                if (widget.onClearFilter != null) {
                  clearFilter();
                  await widget.onClearFilter!(true, filterMap)
                      .then((value) => Navigator.pop(context));
                }
              },
              child: const Text('Clear', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}

////_QueryFilter
class _QueryFilter extends StatefulWidget {
  const _QueryFilter({
    Key? key,
    required this.controller,
    required this.onClear,
    required this.onApply,
    this.hint,
  }) : super(key: key);
  final TextEditingController controller;
  final String? hint;
  final Future<void> Function(String? value) onClear;
  final Future<void> Function(String value) onApply;

  @override
  State<_QueryFilter> createState() => _QueryFilterState();
}

class _QueryFilterState extends State<_QueryFilter> {
  late TextEditingController controller;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    setState(() => loading = false);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CupertinoActivityIndicator())
        : _buildQuery(context).paddingOnly(bottom: DEFAULT_PADDING);
  }

  Widget _buildQuery(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: TextFormField(
            controller: controller,
            onChanged: (val) => widget.onApply(val),
            style: const TextStyle(
              fontSize: 14,
              // color: appStore.isDarkMode ? Colors.white : Colors.black
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(DEFAULT_PADDING / 2),
              isDense: true,
              filled: true,
              hintText: widget.hint,
              suffixIcon: IconButton(
                onPressed: () async {
                  controller.clear();
                  await widget.onClear(controller.text);
                },
                icon: FaIcon(FontAwesomeIcons.xmark,
                    size: 15,
                    color: appStore.isDarkMode
                        ? Colors.white70
                        : Colors.grey.shade500),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DEFAULT_RADIUS)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
                borderSide: BorderSide(
                    color: appStore.isDarkMode
                        ? Colors.white70
                        : Colors.grey.shade500),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
                borderSide: BorderSide(
                    color: appStore.isDarkMode
                        ? Colors.white70
                        : Colors.grey.shade500),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
                borderSide: BorderSide(
                    color: appStore.isDarkMode
                        ? Colors.white70
                        : Colors.grey.shade500),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
                borderSide: BorderSide(
                    color: appStore.isDarkMode
                        ? Colors.white70
                        : Colors.grey.shade500),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

////_DateFilter
class _DateFilter extends StatefulWidget {
  const _DateFilter({
    Key? key,
    required this.data,
    required this.onClear,
    required this.onApply,
  }) : super(key: key);
  final List<FilterDateData> data;
  final Future<void> Function(DateTime? value) onClear;
  final Future<void> Function(DateTime? value) onApply;

  @override
  State<_DateFilter> createState() => _DateFilterState();
}

class _DateFilterState extends State<_DateFilter> {
  late List<FilterDateData> data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      data = widget.data;
      setState(() => loading = false);
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CupertinoActivityIndicator())
        : Column(
                children: data.map((e) => _buildStartDate(context, e)).toList())
            .paddingOnly(bottom: DEFAULT_PADDING);
  }

  Widget _buildStartDate(BuildContext context, FilterDateData item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.title),
        GestureDetector(
          onTap: () async {
            item.value = await showDatePicker(
              context: context,
              initialDate: item.value ?? DateTime.now(),
              firstDate: DateTime(2015, 8),
              lastDate: DateTime.now().add(const Duration(days: 0)),
            );
            widget.onApply(item.value);
            setState(() {});
          },
          child: Container(
            height: 50,
            width: context.width(),
            padding: const EdgeInsets.all(DEFAULT_PADDING / 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
            ),
            child: Row(
              children: [
                assetImages(MyPng.icCalendar,
                    width: 15,
                    height: 15,
                    color: appStore.isDarkMode
                        ? Colors.white70
                        : Colors.grey.shade500),
                width10(),
                Expanded(
                  child: Text(
                    item.value == null
                        ? 'Select Date'
                        : MyDateUtils.formatDate(item.value),
                    style: TextStyle(
                        color: appStore.isDarkMode
                            ? Colors.white70
                            : Colors.grey.shade500),
                  ),
                ),
                if (item.value != null)
                  IconButton(
                    onPressed: () {
                      item.value = null;
                      widget.onClear(item.value);
                      setState(() {});
                    },
                    icon: FaIcon(FontAwesomeIcons.xmark,
                        size: 15,
                        color: appStore.isDarkMode
                            ? Colors.white70
                            : Colors.grey.shade500),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FilterItem {
  FilterItem({
    required this.tag,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.type,
    this.initialValue,
  });
  final String tag;
  final String label;
  final String subtitle;
  final Widget icon;
  final Color color;
  final Color textColor;
  final FilterType type;
  dynamic initialValue;
}

enum FilterType {
  query,
  date,
  radio,
  multiChoice,
  dropdown,
}

abstract class FilterData {
  FilterData({required this.tag});
  final dynamic tag;
}

class FilterDataQuery extends FilterData {
  FilterDataQuery({required this.query, required this.value, dynamic tag})
      : super(tag: tag);

  final String query;
  final dynamic value;
}

class FilterDataRadio extends FilterData {
  FilterDataRadio({required this.value, required this.key, dynamic tag})
      : super(tag: tag);
  final dynamic key;
  final List<FilterDataRadioItem> value;
}

class FilterDataRadioItem {
  FilterDataRadioItem({this.icon, required this.label, required this.key});
  final dynamic key;
  final String label;
  final Widget? icon;
}

class FilterDataMultiChoice extends FilterData {
  FilterDataMultiChoice({required this.value, required this.key, dynamic tag})
      : super(tag: tag);
  final dynamic value;
  final dynamic key;
}

class FilterDataDropdown extends FilterData {
  FilterDataDropdown({required this.value, required this.key, dynamic tag})
      : super(tag: tag);
  final dynamic value;
  final dynamic key;
}

class FilterDateData extends FilterData {
  FilterDateData(
      {required this.value,
      required this.key,
      required this.title,
      this.hint = 'Select Date',
      dynamic tag})
      : super(tag: tag);

  final String title;
  final String? hint;
  DateTime? value;
  final dynamic key;
}
