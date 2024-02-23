import 'package:coinxfiat/database/dio/dio_base_index.dart';
import 'package:coinxfiat/services/service_index.dart';
import 'package:coinxfiat/store/store_index.dart';
import 'package:dio/dio.dart';
import '../../../utils/utils_index.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  int maxCharactersPerLine = 200;

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.extra.addAll({'response_time': DateTime.now()});
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    logger.i(
      'onResponse:',
      tag:
          '${response.requestOptions.method}  ${response.requestOptions.path} ${response.statusCode} ${calculateResponseTime(response.requestOptions.extra['response_time'])}ms',
    );

    /// is is_logged_in==0 then show logout dialog and clear all data

    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    logger.e('onError:',
        tag:
            '${err.requestOptions.method}  ${err.requestOptions.path} ${err.response?.statusCode} ${calculateResponseTime(err.requestOptions.extra['response_time'])}ms',
        error: err.response?.data);
    ApiHandler.getMessage(err);
    pl('is_logged_in: ${err.response?.data['is_logged_in']}');
    if (err.response?.data['is_logged_in'] == 0 &&
        appStore.isSessionExpired != true) {
      await appStore.setSessionExpired(true);
      await AuthService().logoutUser();
    }
    return super.onError(err, handler);
  }

  int calculateResponseTime(DateTime startTime) {
    final endTime = DateTime.now();
    int difference = endTime.difference(startTime).inMilliseconds;
    return difference;
  }
}
