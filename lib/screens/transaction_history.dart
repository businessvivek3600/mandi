import 'package:coinxfiat/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../component/component_index.dart';
import '../constants/constants_index.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Transaction History'),
          actions: [
            ///filter
            IconButton(
              icon: Badge(
                  isLabelVisible: isFilter,
                  child: assetImages(MyPng.icFilter, color: Colors.white)),
              onPressed: () => _showFilter(context),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildAppliedFilterChips(context),
            Expanded(
              child: AnimatedListView(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return _historyTile(context, index);
                  }),
            ),
          ],
        ));
  }

  Container _historyTile(BuildContext context, int index) {
    String trxId = 'P7HRFF6F9N78';
    int status = index % 3 == 0 ? 1 : 0;
    bool credited = index % 3 == 1 ? true : false;

    return Container(
      margin: const EdgeInsets.all(DEFAULT_PADDING / 2),
      padding: const EdgeInsets.all(DEFAULT_PADDING / 2),
      decoration: boxDecorationRoundedWithShadow(DEFAULT_RADIUS.toInt(),
          backgroundColor: context.cardColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Transform.rotate(
              angle: 3.14 / 4,
              child: Icon(
                !credited
                    ? FontAwesomeIcons.arrowUp
                    : FontAwesomeIcons.arrowDown,
                size: 24,
                color: !credited ? runningColor : completedColor,
              ),
            ),
          ),
          10.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${trxId.substring(0, trxId.length > 5 ? 5 : trxId.length)}...${trxId.substring(trxId.length - 5, trxId.length - 1)}',
                    style: primaryTextStyle(size: 12),
                  ),
                  10.width,
                  const FaIcon(FontAwesomeIcons.copy, size: 12).onTap(() {}),
                ],
              ),
              5.height,
              Text('${1.09897657 * index} BTC', style: boldTextStyle()),
              5.height,
              Text(
                'Added With Your ETH Wallet For A Buy Trade',
                style: primaryTextStyle(size: 10),
              ),
            ],
          ).expand(),
          10.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                  MyDateUtils.formatDateAsToday(
                      DateTime.now().subtract(Duration(days: index)),
                      'dd MMM yyyy\nhh:mm a'),
                  textAlign: TextAlign.end,
                  style: secondaryTextStyle()),
            ],
          ),
        ],
      ),
    );
  }

  final queryKey = 'ad_filter_query';
  final remarkKey = 'ad_filter_remark';
  final dateKey = 'ad_filter_date';
  bool isFilter = false;
  bool queryFilter = false;
  bool remarkFilter = false;
  bool dateFilter = false;
  Map<FilterItem, dynamic> appliedFilter = {};

  applyFilter(bool val, Map<FilterItem, dynamic> data) {
    isFilter = val;
    appliedFilter = data;
    logger.w('Filter Data',
        error: data.entries
            .map((e) =>
                '\n${e.key.tag} ${e.key.initialValue.runtimeType} : ${_getFilterValueByKey(e.key.tag)}')
            .toList(),
        tag: 'ad_filter');
    _checkFilter();
  }

  dynamic _getFilterValueByKey(String tag) {
    bool contains = appliedFilter.keys
        .any((element) => element.tag == tag && element.initialValue != null);
    if (contains) {
      final value = appliedFilter.keys
          .firstWhere((element) => element.tag == tag)
          .initialValue;
      switch (value.runtimeType) {
        case DateTime:
          print('datetime $tag ${value.runtimeType}');
          return value;
        case FilterDataQuery:
          return value.value;
        case FilterDataRadioItem:
          return value;
        case FilterDataMultiChoice:
          return value.value.join(',');
        case String:
          return (value as String).validate();
        default:
          return value.toString();
      }
    }
    return null;
  }

  _checkFilter() {
    queryFilter = _hasValue(queryKey, ['', null]);
    remarkFilter = _hasValue(remarkKey, null);
    dateFilter = _hasValue(dateKey, null);
    isFilter = queryFilter || remarkFilter || dateFilter;
    setState(() {});
  }

  _clearFilterByKey(String tag) {
    appliedFilter.keys
        .where((element) => element.tag == tag)
        .toList()
        .forEach((element) {
      if (element.tag == queryKey) {
        element.initialValue = '';
      } else if (element.tag == remarkKey) {
        element.initialValue = null;
      } else if (element.tag == dateKey) {
        element.initialValue = null;
      }
    });
    _checkFilter();
  }

  _hasValue(String tag, [dynamic defaultValue]) {
    bool contains = appliedFilter.keys.any((element) => element.tag == tag);
    if (contains) {
      FilterItem item =
          appliedFilter.keys.firstWhere((element) => element.tag == tag);
      if (tag == queryKey) {
        //   print('query ${item.initialValue.runtimeType}');
        //   bool has = item.initialValue != null &&
        //       item.initialValue.toString().isNotEmpty;
        //   print('has $has');
        return item.initialValue != null &&
            item.initialValue.toString().isNotEmpty;
      } else if (tag == remarkKey) {
        return item.initialValue != null;
      } else if (tag == dateKey) {
        return item.initialValue != null;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  AnimatedCrossFade _buildAppliedFilterChips(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState:
          isFilter ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstCurve: Curves.fastLinearToSlowEaseIn,
      secondCurve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(milliseconds: 500),
      secondChild: const SizedBox(),
      firstChild: SizedBox(
        height: queryFilter || remarkFilter || dateFilter ? 50 : 0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ///Currency Code
            if (queryFilter)
              FilterChipItem(
                tag: queryKey,
                label: capText(
                    _getFilterValueByKey(queryKey).toString().validate(),
                    context,
                    color: Colors.white),
                subtitle: 'Currency Code',
                icon: const FaIcon(FontAwesomeIcons.magnifyingGlass,
                    size: 15, color: Colors.white),
                color: Colors.grey.shade500,
                textColor: Colors.white,
                onTap: () => _showFilter(context, launchFrom: queryKey),
                onClear: (tag) => _clearFilterByKey(tag),
              ).paddingOnly(left: DEFAULT_PADDING),

            ///Currency Code
            if (remarkFilter)
              FilterChipItem(
                tag: remarkKey,
                label: capText(
                    _getFilterValueByKey(remarkKey).toString().validate(),
                    context,
                    color: Colors.white),
                subtitle: 'Remark',
                icon: const FaIcon(FontAwesomeIcons.rectangleXmark,
                    size: 15, color: Colors.white),
                color: Colors.grey.shade500,
                textColor: Colors.white,
                onTap: () => _showFilter(context, launchFrom: remarkKey),
                onClear: (tag) => _clearFilterByKey(tag),
              ).paddingOnly(left: DEFAULT_PADDING),

            ///date
            if (_getFilterValueByKey(dateKey) != null)
              FilterChipItem(
                tag: dateKey,
                label: capText(
                    MyDateUtils.formatDateAsToday(
                        _getFilterValueByKey(dateKey).toString().validate()),
                    context,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                subtitle: 'End Date',
                icon: const FaIcon(FontAwesomeIcons.calendarDays,
                    size: 15, color: Colors.white),
                color: Colors.blue,
                textColor: Colors.white,
                onTap: () => _showFilter(context, launchFrom: dateKey),
                onClear: (tag) => _clearFilterByKey(tag),
              ).paddingOnly(left: DEFAULT_PADDING),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showFilter(BuildContext context, {String? launchFrom}) {
    ///dummy filter item
    List<FilterItem> filterItem = [
      ///Transaction query
      FilterItem(
        tag: queryKey,
        label: 'Currency Code',
        subtitle: 'Search By currency code',
        icon: const FaIcon(FontAwesomeIcons.magnifyingGlass,
            size: 15, color: Colors.white),
        color: Colors.blue,
        textColor: Colors.white,
        type: FilterType.query,
        initialValue: _getFilterValueByKey(queryKey),
      ),

      ///Remark query
      FilterItem(
        tag: remarkKey,
        label: 'Remark',
        subtitle: 'Search By remark ',
        icon: const FaIcon(FontAwesomeIcons.rectangleXmark,
            size: 15, color: Colors.white),
        color: Colors.blue,
        textColor: Colors.white,
        type: FilterType.query,
        initialValue: _getFilterValueByKey(remarkKey),
      ),

      FilterItem(
        tag: dateKey,
        label: "Date",
        subtitle: 'The date of transaction',
        icon: const FaIcon(FontAwesomeIcons.calendarDays,
            size: 15, color: Colors.white),
        color: Colors.blue,
        textColor: Colors.white,
        type: FilterType.date,
        initialValue: _getFilterValueByKey(dateKey),
      ),
    ];

    ///dummy filter data for each filter item and type withsame tag
    List<FilterData> filterData = [
      ///query1
      FilterDataQuery(query: queryKey, tag: queryKey, value: ''),

      ///query2
      FilterDataQuery(query: remarkKey, tag: remarkKey, value: ''),

      ///date
      FilterDateData(
          key: 'ad_filter_dates',
          tag: dateKey,
          title: 'Date',
          value: DateTime.now().subtract(const Duration(days: 1))),
    ];

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (context) => BottomSheetFilter(
              key: const Key('ad_filter'),
              title: 'Transaction History Filter',
              subTitle: 'Filter your transaction history',
              topRadius: 10,
              topPadding: context.height() * 0.3,
              filterItem: filterItem,
              filterData: filterData,
              launchFrom: launchFrom,
              onApplyFilter: (val, data) async => applyFilter(val, data),
              onClearFilter: (val, data) async => applyFilter(val, data),
              onResetFilter: (val, data) async => applyFilter(val, data),
            ));
  }
}
