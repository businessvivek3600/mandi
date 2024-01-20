import '../constants/constants_index.dart';
import '../database/database_index.dart';
import '../utils/utils_index.dart';

class Apis {
  static const tag = 'Apis';

  /// get dashboard data
  static Future<(bool, Map<String, dynamic>)> getDashboardDataApi() async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(ApiConst.dashboard, method: ApiMethod.GET);
      if (status && data.isNotEmpty) {
        return (true, data);
      } else {
        return (false, <String, dynamic>{});
      }
    } catch (e) {
      logger.e('register error : $e', tag: tag);
    }
    return (false, <String, dynamic>{});
  }

  /// get mondi result history
  static Future<(bool, Map<String, dynamic>)> getMondiResultHistoryApi({
    required String type,
    String? game,
    required int page,
  }) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(
              ApiConst.mondiResultHistory(type, 20, game ?? '', page),
              method: ApiMethod.GET);
      if (status && data.isNotEmpty) {
        return (true, data);
      } else {
        return (false, <String, dynamic>{});
      }
    } catch (e) {
      logger.e('mondiResultHistory error : $e', tag: tag);
    }
    return (false, <String, dynamic>{});
  }

  /// get single jodi chart
  static Future<(bool, Map<String, dynamic>)> getSingleJodiChartApi({
    required String type,
    required int page,
  }) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(ApiConst.singleJodiChart(type, 20, page),
              method: ApiMethod.GET);
      if (status && data.isNotEmpty) {
        return (true, data);
      } else {
        return (false, <String, dynamic>{});
      }
    } catch (e) {
      logger.e('singleJodiChart error : $e', tag: tag);
    }
    return (false, <String, dynamic>{});
  }

  ///update profile
  static Future<(bool status, Map<String, dynamic> data, String? message)>
      updateProfileApi(Map<String, dynamic> info) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(ApiConst.updateProfile,
              method: ApiMethod.POST, data: info);
      if (status && data.isNotEmpty) {
        return (true, data, message);
      } else {
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      logger.e('updateProfileApi error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, null);
  }
}
