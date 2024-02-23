import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../database/database_index.dart';
import '../../model/model_index.dart';
import '../../services/service_index.dart';
import '../../store/store_index.dart';
import '../../utils/utils_index.dart';
import '../../widgets/widget_index.dart';

class MondiResultHistoryPage extends StatefulWidget {
  const MondiResultHistoryPage({super.key});

  @override
  State<MondiResultHistoryPage> createState() => _MondiResultHistoryPageState();
}

class _MondiResultHistoryPageState extends State<MondiResultHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  ValueNotifier<List<GameResult>> games = ValueNotifier<List<GameResult>>([]);
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
  ValueNotifier<Set<String>> selectedJodi = ValueNotifier<Set<String>>({});
  ValueNotifier<Set<String>> selectedFirst = ValueNotifier<Set<String>>({});
  ValueNotifier<Set<String>> selectedLast = ValueNotifier<Set<String>>({});
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
        games.value.clear();
        selectedJodi.value.clear();
        selectedFirst.value.clear();
        selectedLast.value.clear();
      
        getMondiResultHistory(isRefresh: true);
      });
    });
    getMondiResultHistory(isRefresh: true);
  }

  Future<void> getMondiResultHistory({bool isRefresh = false}) async {
    isLoading.value = isRefresh;
    if (isRefresh) {
      games.value = [];
      currentPage = 1;
      total = 0;
      hasMore = false;
    } else {
      currentPage++;
    }
    await Apis.getMondiResultHistoryApi(
            type: type, game: gameName, page: currentPage)
        .then((value) {
      if (value.$1) {
        currentPage = tryCatch<int>(() => value.$2['data']['current_page']) ??
            currentPage;
        total = tryCatch<int>(() => value.$2['data']['total']) ?? total;
        List<GameResult> list = tryCatch<List<GameResult>>(() =>
                (value.$2['data']['data'] ?? [])
                    .map<GameResult>((e) => GameResult.fromJson(e))
                    .toList()) ??
            [];
        if (isRefresh) {
          games.value = list;
        } else {
          games.value = [...games.value, ...list];
        }
        hasMore = games.value.length < total;
        pl('games: ${games.value.length} total: $total hasMore: $hasMore',
            'Mondi result List Page');
      }
    });
    isLoading.value = false;
  }

  void onJodiTap(String number) => setState(() {
        selectedJodi.value.contains(number)
            ? selectedJodi.value.remove(number)
            : selectedJodi.value.add(number);
      });
  void onFirstTap(String number) => setState(() {
        selectedFirst.value.contains(number)
            ? selectedFirst.value.remove(number)
            : selectedFirst.value.add(number);
      });
  void onLastTap(String number) => setState(() {
        selectedLast.value.contains(number)
            ? selectedLast.value.remove(number)
            : selectedLast.value.add(number);
      });

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
              titleSpacing: 0,
              title: const Text('Single Jodi Chart'),
              actions: [
                /// dropdown from dashboardstore.games
                if (dashboardStore.gamesList.isNotEmpty)
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: gameName,
                      hint: Text('Select Game',
                          style: boldTextStyle(color: white)),
                      icon: const Icon(Icons.keyboard_arrow_down, color: white),
                      iconSize: 24,
                      elevation: 16,
                      style: boldTextStyle(),
                      selectedItemBuilder: (BuildContext context) =>
                          dashboardStore.gamesList
                              .map<Widget>((e) => Text(
                                    e.title.validate(),
                                    textAlign: TextAlign.end,
                                    style: boldTextStyle(color: white),
                                  ).center())
                              .toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          gameName = newValue;
                          getMondiResultHistory(isRefresh: true);
                        }
                      },
                      items: dashboardStore.gamesList
                          .map<DropdownMenuItem<String>>(
                              (e) => DropdownMenuItem<String>(
                                    value: e.id.toString(),
                                    child: Text(e.title.validate()),
                                  ))
                          .toList(),
                    ),
                  ),
              ],
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
                headerWidget('DATE', 'JODI', 'XXXX', 'XXX'),

                ///list
                Expanded(child: isLoading ? _loadingList() : _buildList())
              ],
            ),
          );
        });
  }

  Widget headerWidget(
      String title1, String title2, String title3, String title4) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title1, style: boldTextStyle()).center().expand(),
          VerticalDivider(
              color: Colors.black.withOpacity(0.5), thickness: 1, width: 0),
          Text(title2, style: boldTextStyle()).center().expand(),
          VerticalDivider(
              color: Colors.black.withOpacity(0.5), thickness: 1, width: 0),
          Text(title3, style: boldTextStyle()).center().expand(),
          VerticalDivider(
              color: Colors.black.withOpacity(0.5), thickness: 1, width: 0),
          Text(title4, style: boldTextStyle()).center().expand(),
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
    return ValueListenableBuilder<List<GameResult>>(
        valueListenable: games,
        builder: (_, list, __) {
          if (list.isEmpty) {
            return EmptyListWidget(
              message: 'No Data Available',
              width: 300,
              height: 300,
              refresh: () => getMondiResultHistory(isRefresh: true),
            );
          }
          return ValueListenableBuilder<dynamic>(
              valueListenable: selectedFirst,
              builder: (_, selectedFirstvalue, c) {
                return ValueListenableBuilder<dynamic>(
                    valueListenable: selectedLast,
                    builder: (_, selectedLastValue, c) {
                      return ValueListenableBuilder<dynamic>(
                          valueListenable: selectedJodi,
                          builder: (_, selectedJodiValue, c) {
                            pl('selectedFirst:  selectedJodi: $selectedJodiValue selectedFirst: $selectedFirstvalue selectedLast: $selectedLastValue',
                                'Mondi result List Page');
                            return AnimatedListView(
                              onSwipeRefresh: () =>
                                  getMondiResultHistory(isRefresh: true),
                              onNextPage: hasMore
                                  ? () => getMondiResultHistory()
                                  : null,
                              padding: const EdgeInsets.only(bottom: 60),
                              itemCount: list.length,
                              listAnimationType: ListAnimationType.FadeIn,
                              itemBuilder: (context, index) {
                                GameResult game = list[index];
                                bool last = index == list.length - 1;
                                String jodi = game.number.validate().toString();
                                String numberFirst = game.number
                                    .validate()
                                    .toString()
                                    .getFirstLetter('X');
                                String numberLast = game.number
                                    .validate()
                                    .toString()
                                    .getLastLetter('X');
                                bool isJodi = false;
                                bool isFirst = false;
                                bool isLast = false;

                                if (selectedJodiValue.contains(jodi)) {
                                  isJodi = true;
                                }
                                if (selectedFirstvalue.contains(numberFirst)) {
                                  isFirst = true;
                                }
                                if (selectedLastValue.contains(numberLast)) {
                                  isLast = true;
                                }
                                pl('jodi: $jodi $isJodi numberFirst: $numberFirst $isFirst numberLast: $numberLast $isLast',
                                    'Mondi result List Page');

                                return rowWidget(
                                  game.date.validate(),
                                  jodi,
                                  numberFirst,
                                  numberLast,
                                  last,
                                  onJodiTap: onJodiTap,
                                  onFirstTap: onFirstTap,
                                  onLastTap: onLastTap,
                                  isJodi: isJodi,
                                  isFirst: isFirst,
                                  isLast: isLast,
                                );
                              },
                              // separatorBuilder: (context, index) => Divider(
                              //     color: Colors.grey.withOpacity(0.2), thickness: 1, height: 0),
                            );
                          });
                    });
              });
        });
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
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.amber,
      Colors.grey,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
      Colors.cyan,
    ];
    Color jodiColor = isJodi
        ? Color(int.parse(generateColorCode(jodi.split('').join('dfd'))
                .replaceAll('#', '0xFF')))
            .withOpacity(0.8)
        : Colors.transparent;
    Color firstColor = isFirst
        ? Color(int.parse(generateColorCode(gameFirst.split('').join('dfd'))
                .replaceAll('#', '0xFF')))
            .withOpacity(0.6)
        : Colors.transparent;
    Color lastColor =
        isLast ? colors[gameLast.split('').last.toInt()] : Colors.transparent;
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
              color: jodiColor,
              child: Text(jodi,
                      style: TextStyle(shadows: [
                        if (isJodi)
                          Shadow(
                              color: Colors.black.withOpacity(1),
                              offset: const Offset(1, 1),
                              blurRadius: 3),
                      ], color: isJodi ? Colors.white : Colors.black))
                  .center()
                  .onTap(() => onJodiTap?.call(jodi))).expand(),
          VerticalDivider(
              color: Colors.black.withOpacity(0.5), thickness: 1, width: 0),
          Container(
              color: firstColor,
              child: Text(gameFirst,
                      style: boldTextStyle(
                          color: isFirst ? Colors.white : Colors.black))
                  .center()
                  .onTap(() => onFirstTap?.call(gameFirst))).expand(),
          VerticalDivider(
              color: Colors.black.withOpacity(0.5), thickness: 1, width: 0),
          Container(
              color: lastColor,
              child: Text(gameLast,
                      style: boldTextStyle(
                          color: isLast ? Colors.white : Colors.black))
                  .center()
                  .onTap(() => onLastTap?.call(gameLast))).expand(),
        ],
      ),
    );
  }
}
