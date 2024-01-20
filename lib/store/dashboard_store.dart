import 'dart:developer';

import 'package:mobx/mobx.dart';
import '../model/model_index.dart';
import '../services/service_index.dart';
import '../utils/utils_index.dart';

part 'dashboard_store.g.dart';

final dashboardStore = DashboardStore();

class DashboardStore = _DashboardStore with _$DashboardStore;

abstract class _DashboardStore with Store {
  @observable
  bool isLoading = true;

  @observable
  int totalTrade = 0;

  @observable
  int runningTrade = 0;

  @observable
  int completedTrade = 0;

  @observable
  int gateways = 0;

  @observable
  int totalReferral = 0;

  @observable
  List<Game> gamesList = [];

  @action
  void setLoading(bool value) {
    isLoading = value;
  }

  @action
  void setTotalTrade(int value) {
    totalTrade = value;
  }

  @action
  void setRunningTrade(int value) {
    runningTrade = value;
  }

  @action
  void setCompletedTrade(int value) {
    completedTrade = value;
  }

  @action
  void setGateways(int value) {
    gateways = value;
  }

  @action
  void setTotalReferral(int value) {
    totalReferral = value;
  }

  @action
  void setGamesList(List<Game> value) {
    gamesList = value;
    log('gamesList : $gamesList');
  }

  @action
  Future<void> getDashboardData() async {
    try {
      setLoading(true);
      await Apis.getDashboardDataApi().then((value) {
        Map<String, dynamic> data = value.$2['data'];
        if (value.$1 && data.isNotEmpty) {
          setTotalReferral(data['referral_count'] ?? 0);

          try {
            setGamesList(((data['games'] != null && data['games'] is List)
                    ? data['games']
                    : [])
                .map<Game>((e) => Game.fromJson(e))
                .toList());
          } catch (e) {
            logger.e('games list error : ',
                error: e, tag: 'dashboard_store.dart');
          }
        }
      }).catchError((e) {
        logger.e(e);
      });
    } catch (e) {
      logger.e(e);
    }
    setLoading(false);
  }
}
