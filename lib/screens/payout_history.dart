import 'package:coinxfiat/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../component/component_index.dart';
import '../constants/constants_index.dart';

class PayoutHistory extends StatefulWidget {
  const PayoutHistory({super.key});

  @override
  State<PayoutHistory> createState() => _PayoutHistoryState();
}

class _PayoutHistoryState extends State<PayoutHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Payout History'),
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
    String trxId = 'TE3LNFbdDi8vEgvGW9XqskGZ8hx6XgEZeW';
    int status = index % 3 == 0 ? 1 : 0;
    return Container(
      margin: const EdgeInsets.all(DEFAULT_PADDING / 2),
      padding: const EdgeInsets.all(DEFAULT_PADDING / 2),
      decoration: boxDecorationRoundedWithShadow(DEFAULT_RADIUS.toInt(),
          backgroundColor: context.cardColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: boxDecorationRoundedWithShadow(DEFAULT_RADIUS.toInt(),
                backgroundColor: context.primaryColor),
            child: assetImages(MyPng.logoLWhite,
                height: 50, width: 50, fit: BoxFit.cover),
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

              ///charges
              Text('Charges: ${1.09897657 * index} BTC',
                  style: secondaryTextStyle()),
              Text(
                  MyDateUtils.formatDateAsToday(
                      DateTime.now().subtract(Duration(days: index)),
                      'dd MMM yyyy hh:mm a'),
                  style: secondaryTextStyle()),
            ],
          ).expand(),
          10.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${1.09897657 * index} BTC', style: boldTextStyle()),
              Row(
                children: [
                  FaIcon(
                      status == 0
                          ? FontAwesomeIcons.clock
                          : FontAwesomeIcons.circleCheck,
                      size: 12,
                      color: status == 0 ? holdColor : completedColor),
                  5.width,
                  Text(
                    status == 0 ? 'Pending' : 'Completed',
                    style: secondaryTextStyle(
                        color: status == 0 ? holdColor : completedColor),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  final queryKey = 'ad_filter_query';
  final paymentTypeKey = 'ad_filter_payment_type';
  final dateKey = 'ad_filter_date';
  bool isFilter = false;
  bool queryFilter = false;
  bool paymentTypeFilter = false;
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
    paymentTypeFilter = _hasValue(paymentTypeKey, null);
    dateFilter = _hasValue(dateKey, null);
    isFilter = queryFilter || paymentTypeFilter || dateFilter;
    setState(() {});
  }

  _clearFilterByKey(String tag) {
    appliedFilter.keys
        .where((element) => element.tag == tag)
        .toList()
        .forEach((element) {
      if (element.tag == queryKey) {
        element.initialValue = '';
      } else if (element.tag == paymentTypeKey) {
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
      } else if (tag == paymentTypeKey) {
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
        height: queryFilter || paymentTypeFilter || dateFilter ? 50 : 0,
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
                onTap: () => _showFilter(context),
                onClear: (tag) => _clearFilterByKey(tag),
              ).paddingOnly(left: DEFAULT_PADDING),

            /// type sell|buy
            if (paymentTypeFilter &&
                _getFilterValueByKey(paymentTypeKey) != null)
              FilterChipItem(
                tag: paymentTypeKey,
                label: capText(
                    _getFilterValueByKey(paymentTypeKey)!
                        .label
                        .toString()
                        .validate(),
                    context,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                subtitle: 'Type',
                icon: const FaIcon(FontAwesomeIcons.arrowUpWideShort,
                    size: 15, color: Colors.white),
                color: sellColor,
                textColor: Colors.white,
                onTap: () => _showFilter(context),
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
                onTap: () => _showFilter(context),
                onClear: (tag) => _clearFilterByKey(tag),
              ).paddingOnly(left: DEFAULT_PADDING),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showFilter(BuildContext context) {
    List<FilterDataRadioItem> paymentTypes = [
      ///All Payments, Pending Payments, Completed Payments, Rejected Payments
      FilterDataRadioItem(
          key: 'ad_filter_payment_type_all',
          label: 'All Payments',
          icon: const FaIcon(FontAwesomeIcons.moneyBill,
              size: 15, color: Colors.white)),
      FilterDataRadioItem(
          key: 'ad_filter_payment_type_pending',
          label: 'Pending Payments',
          icon: const FaIcon(FontAwesomeIcons.clock,
              size: 15, color: Colors.white)),
      FilterDataRadioItem(
          key: 'ad_filter_payment_type_completed',
          label: 'Completed Payments',
          icon: const FaIcon(FontAwesomeIcons.circleCheck,
              size: 15, color: Colors.white)),
      FilterDataRadioItem(
          key: 'ad_filter_payment_type_rejected',
          label: 'Rejected Payments',
          icon: const FaIcon(FontAwesomeIcons.circleXmark,
              size: 15, color: Colors.white)),
    ];

    ///dummy filter item
    List<FilterItem> filterItem = [
      ///currency code
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

      ///type
      FilterItem(
        tag: paymentTypeKey,
        label: 'Payment Type',
        subtitle: 'Filter by payment type',
        icon: const FaIcon(FontAwesomeIcons.arrowUpWideShort,
            size: 15, color: Colors.white),
        color: sellColor,
        textColor: Colors.white,
        type: FilterType.radio,
        initialValue: _getFilterValueByKey(paymentTypeKey),
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
      FilterDataQuery(query: queryKey, tag: queryKey, value: 'USD'),

      ///type
      FilterDataRadio(
          key: paymentTypeKey, tag: paymentTypeKey, value: paymentTypes),

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
              title: 'Payout History Filter',
              subTitle: 'Filter your payout history',
              topRadius: 10,
              topPadding: context.height() * 0.3,
              filterItem: filterItem,
              filterData: filterData,
              onApplyFilter: (val, data) async => applyFilter(val, data),
              onClearFilter: (val, data) async => applyFilter(val, data),
              onResetFilter: (val, data) async => applyFilter(val, data),
            ));
  }
}
