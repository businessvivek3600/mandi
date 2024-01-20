import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../model/model_index.dart';
import '../../services/service_index.dart';
import '../../store/store_index.dart';
import '../../utils/utils_index.dart';
import '../../widgets/widget_index.dart';

class SingleJodi {
  DateTime? date;
  Map<String, dynamic>? games;
}

class SingleJodiPage extends StatefulWidget {
  const SingleJodiPage({super.key});

  @override
  State<SingleJodiPage> createState() => _SingleJodiPageState();
}

class _SingleJodiPageState extends State<SingleJodiPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  ValueNotifier<List<String>> games = ValueNotifier<List<String>>([]);
  ValueNotifier<List<SingleJodi>> results = ValueNotifier<List<SingleJodi>>([]);
  Map<String, dynamic> tabs = {
    'this_month': 'This Month',
    // 'last_month': 'Last Month',
    'last_3_month': 'Last 3 Month',
    'last_1_year': 'Last 1 Year',
  };
  late String type;
  String? gameName;
  int currentPage = 1;
  int total = 0;
  bool hasMore = false;
  ValueNotifier<dynamic> selectedJodi = ValueNotifier<dynamic>(null);
  ValueNotifier<dynamic> selectedFirst = ValueNotifier<dynamic>(null);
  ValueNotifier<dynamic> selectedLast = ValueNotifier<dynamic>(null);
  @override
  void initState() {
    super.initState();
    type = tabs.keys.first;
    if (dashboardStore.gamesList.isNotEmpty) {
      gameName = dashboardStore.gamesList.first.id.toString();
    }
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    afterBuildCreated(() {
      _tabController.addListener(() {
        type = tabs.entries.toList()[_tabController.index].key.toLowerCase();
        results.value.clear();
        selectedJodi.value = null;
        selectedFirst.value = null;
        selectedLast.value = null;
        getSingleJodiChartApi(isRefresh: true);
      });
    });
    getSingleJodiChartApi(isRefresh: true);
  }

  Future<void> getSingleJodiChartApi({bool isRefresh = false}) async {
    isLoading.value = isRefresh;
    if (isRefresh) {
      results.value = [];
      currentPage = 1;
      total = 0;
      hasMore = false;
    } else {
      currentPage++;
    }
    // await Apis.getSingleJodiChartApi(type: type, page: currentPage)
    //     .then((value) {
    //   if (value.$1) {
    // currentPage = tryCatch<int>(() => value.$2['data']['current_page']) ??
    //     currentPage;
    // total = tryCatch<int>(() => value.$2['data']['total']) ?? total;
    List<String> gameList = tryCatch<List<String>>(() => ((
                    // value.$2['data']['games']
                    //  ??
                    {
              "1": "FR",
              "2": "GH",
              "3": "GL",
              "4": "DS",
              "5": "PP",
              "6": "HH",
              "7": "KK",
              "8": "FF",
              "9": "LL",
              "10": "SS",
              "11": "RR",
              "12": "TT",
              "13": "CC",
              "14": "XX",
              "15": "VV",
              "16": "BB",
              "17": "MM",
              "18": "YY",
            }) as Map<String, dynamic>)
                .entries
                .map<String>((e) => e.value.toString())
                .toList()) ??
        [];
    List<SingleJodi> resultList = tryCatch<List<SingleJodi>>(() =>
            // ((value.$2['data']['results'] ?? {}) as Map<String, dynamic>)
            randomResult(gameList)
                .entries
                .map<SingleJodi>((e) => SingleJodi()
                  ..date = tryCatch<DateTime>(() => DateTime.tryParse(e.key))
                  ..games = e.value as Map<String, dynamic>?)
                .toList()) ??
        [];
    if (isRefresh) {
      results.value = resultList;
    } else {
      results.value = [...results.value, ...resultList];
    }
    if (gameList.isNotEmpty) {
      games.value = gameList;
    }
    hasMore = results.value.length < total;
    pl('games: ${games.value.length} results: ${results.value.length}  total: $total hasMore: $hasMore',
        'Mondi result List Page');
    // }
    // });
    isLoading.value = false;
  }

  void onJodiTap(String number) => selectedJodi.value = number;
  void onFirstTap(String number) => selectedFirst.value = number;
  void onLastTap(String number) => selectedLast.value = number;

  Map<String, Map<String, dynamic>> randomResult(List<String> list) {
    List<String> keys = list;

    Map<String, Map<String, dynamic>> generatedMap = {};

    for (String date in generateDates()) {
      generatedMap[date] = {};
      for (String key in keys) {
        int random = Random().nextInt(100);
        generatedMap[date]![key] = random < 30 ? null : random;
      }
    }
    return generatedMap;
  }

  List<String> generateDates() {
    // Replace this with your logic to generate the list of dates.
    return [
      "2024-01-19",
      "2024-01-20",
      "2024-01-21",
      "2024-01-22",
      "2024-01-23",
      "2024-01-24",
      "2024-01-25",
      "2024-01-26",
      "2024-01-27",
      "2024-01-28",
      "2024-01-29",
      "2024-01-30",
      "2024-01-31",
      "2024-02-01",
      "2024-02-02",
      "2024-02-03",
      "2024-02-04",
      "2024-02-05",
      "2024-02-06",
      "2024-02-07",
      "2024-02-08",
      "2024-02-09",
      "2024-02-10",
      "2024-02-11",
      "2024-02-12",
      "2024-02-13",
      "2024-02-14",
      "2024-02-15",
      "2024-02-16",
      "2024-02-17",
      "2024-02-18",
    ];
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (_, isLoading, __) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: const Text('Single Jodi Result'),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                labelStyle: boldTextStyle(),
                tabs: tabs.entries.map((e) => Tab(text: e.value)).toList(),
              ),
            ),
            body: Column(
              children: [
                /// header

                ///list
                Expanded(child: isLoading ? _loadingList() : _buildList())
              ],
            ),
          );
        });
  }

  Widget headerWidget(String title1, List<String> games) {
    return Container(
      height: 40,
      // padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title1,
            style: boldTextStyle(),
            textAlign: TextAlign.center,
          ).center().expand(),
          VerticalDivider(
                  color: Colors.black.withOpacity(0.5), thickness: 1, width: 0)
              .visible(games.isNotEmpty),
          ...games
              .map(
                (e) => Row(
                  children: [
                    Text(e, style: boldTextStyle()).center().expand(),
                    VerticalDivider(
                            color: Colors.black.withOpacity(0.5),
                            thickness: 1,
                            width: 0)
                        .visible(games.indexOf(e) < games.length - 1),
                  ],
                ).expand(),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _loadingList() {
    return AnimatedListView(
      itemCount: 10,
      listAnimationType: ListAnimationType.FadeIn,
      itemBuilder: (_, index) => ListTile(
        title: Container(
          height: 20,
          width: 100,
          color: Colors.grey.withOpacity(0.2),
        ),
        subtitle: Container(
          height: 20,
          width: 100,
          color: Colors.grey.withOpacity(0.2),
        ),
      ).skeletonize(enabled: true),
    );
  }

  Widget _buildList() {
    return ValueListenableBuilder(
        valueListenable: games,
        builder: (_, games, __) {
          return Column(
            children: [
              headerWidget('DATE', games),
              Expanded(
                child: ValueListenableBuilder<List<SingleJodi>>(
                    valueListenable: results,
                    builder: (_, list, __) {
                      if (list.isEmpty || games.isEmpty) {
                        return EmptyListWidget(
                          message: 'No Data Available',
                          width: 300,
                          height: 300,
                          refresh: () => getSingleJodiChartApi(isRefresh: true),
                        );
                      }

                      return ValueListenableBuilder<dynamic>(
                          valueListenable: selectedFirst,
                          builder: (_, selectedFirst, c) {
                            return ValueListenableBuilder<dynamic>(
                                valueListenable: selectedLast,
                                builder: (_, selectedLast, c) {
                                  return ValueListenableBuilder<dynamic>(
                                      valueListenable: selectedJodi,
                                      builder: (_, selectedValue, c) {
                                        pl('selectedFirst:  selectedJodi: $selectedValue selectedFirst: $selectedFirst selectedLast: $selectedLast',
                                            'Mondi result List Page');
                                        return AnimatedListView(
                                          onSwipeRefresh: () =>
                                              getSingleJodiChartApi(
                                                  isRefresh: true),
                                          onNextPage: hasMore
                                              ? () => getSingleJodiChartApi()
                                              : null,
                                          padding:
                                              const EdgeInsets.only(bottom: 60),
                                          itemCount: list.length,
                                          listAnimationType:
                                              ListAnimationType.FadeIn,
                                          itemBuilder: (context, index) {
                                            SingleJodi singleJodi = list[index];
                                            bool last =
                                                index == list.length - 1;

                                            // String jodi = game.number
                                            //     .validate()
                                            //     .toString();
                                            // String numberFirst = game.number
                                            //     .validate()
                                            //     .toString()
                                            //     .getFirstLetter('X');
                                            // String numberLast = game.number
                                            //     .validate()
                                            //     .toString()
                                            //     .getLastLetter('X');
                                            // bool isJodi = false;
                                            // bool isFirst = false;
                                            // bool isLast = false;

                                            // if (selectedValue == jodi) {
                                            //   isJodi = true;
                                            // }
                                            // if (selectedFirst == numberFirst) {
                                            //   isFirst = true;
                                            // }
                                            // if (selectedLast == numberLast) {
                                            //   isLast = true;
                                            // }
                                            // pl('jodi: $jodi $isJodi numberFirst: $numberFirst $isFirst numberLast: $numberLast $isLast',
                                            //     'Mondi result List Page');

                                            // return rowWidget(
                                            //   game.date.validate(),
                                            //   jodi,
                                            //   numberFirst,
                                            //   numberLast,
                                            //   last,
                                            //   onJodiTap: onJodiTap,
                                            //   onFirstTap: onFirstTap,
                                            //   onLastTap: onLastTap,
                                            //   isJodi: isJodi,
                                            //   isFirst: isFirst,
                                            //   isLast: isLast,
                                            // );
                                            return rowWidget2(
                                                singleJodi: singleJodi,
                                                allGames: games);
                                          },
                                          // separatorBuilder: (context, index) => Divider(
                                          //     color: Colors.grey.withOpacity(0.2), thickness: 1, height: 0),
                                        );
                                      });
                                });
                          });
                    }),
              ),
            ],
          );
        });
  }

  Widget rowWidget2({
    required SingleJodi singleJodi,
    List<String> allGames = const [],
  }) {
    List<MapEntry<String, dynamic>> games =
        allGames.map((e) => MapEntry(e, singleJodi.games?[e] ?? '-')).toList();
    return Container(
      height: 40,
      // padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        // color: selected ? Colors.grey.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            MyDateUtils.formatDate(singleJodi.date, 'dd MMM'),
            textAlign: TextAlign.center,
            style: primaryTextStyle(size: 10),
          ).center().expand(),
          VerticalDivider(
              color: Colors.black.withOpacity(0.5), thickness: 1, width: 0),
          ...games.map(
            (e) => Row(
              children: [
                Container(
                        color: Colors.transparent,
                        child: Text(e.value.toString(),
                                style: boldTextStyle(color: Colors.black))
                            .center())
                    .expand(),
                VerticalDivider(
                        color: Colors.black.withOpacity(0.5),
                        thickness: 1,
                        width: 0)
                    .visible(games.indexOf(e) < games.length - 1),
              ],
            ).expand(),
          ),
        ],
      ),
    );
  }

  Widget rowWidget(
    String date,
    String jodi,
    String gameFirst,
    String gameLast,
    bool last, {
    Function(String val)? onJodiTap,
    Function(String val)? onFirstTap,
    Function(String val)? onLastTap,
    bool isJodi = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    Color jodiColor = Colors.red;
    Color firstColor = Colors.blue;
    Color lastColor = Colors.green;
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        // color: selected ? Colors.grey.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date, style: boldTextStyle()).center().expand(),
          VerticalDivider(
              color: Colors.black.withOpacity(0.5), thickness: 1, width: 0),
          Container(
              color: isJodi ? jodiColor.withOpacity(0.1) : Colors.transparent,
              child: Text(jodi,
                      style: boldTextStyle(
                          color: isJodi ? Colors.red : Colors.black))
                  .center()
                  .onTap(() => onJodiTap?.call(jodi))).expand(),
          VerticalDivider(
              color: Colors.black.withOpacity(0.5), thickness: 1, width: 0),
          Container(
              color: isFirst ? firstColor.withOpacity(0.1) : Colors.transparent,
              child: Text(gameFirst,
                      style: boldTextStyle(
                          color: isFirst ? Colors.blue : Colors.black))
                  .center()
                  .onTap(() => onFirstTap?.call(gameFirst))).expand(),
          VerticalDivider(
              color: Colors.black.withOpacity(0.5), thickness: 1, width: 0),
          Container(
              color: isLast ? lastColor.withOpacity(0.1) : Colors.transparent,
              child: Text(gameLast,
                      style: boldTextStyle(
                          color: isLast ? Colors.green : Colors.black))
                  .center()
                  .onTap(() => onLastTap?.call(gameLast))).expand(),
        ],
      ),
    );
  }
}