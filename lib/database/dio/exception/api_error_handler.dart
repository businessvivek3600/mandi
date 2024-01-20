import 'dart:async';

import 'package:coinxfiat/constants/enums.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/utils_index.dart';
import '../dio_base_index.dart';

class ApiHandler {
  static String tag = 'ApiErrorHandler';
  static dynamic getMessage(error, {String? endpoint, bool showToast = true}) {
    dynamic errorDescription = "";
    if (error is DioException) {
      try {
        if (error.response?.data != null &&
            error.response?.data is Map<String, dynamic>) {
          print('ApiHandler error.response -: ${error.response?.data}');
          errorDescription =
              findErrorMessageInData(error.response?.data?['data']) ??
                  findErrorMessageInData(error.response?.data?['message']) ??
                  'Unexpected error occurred';
        } else if (DioExceptionType.values.contains(error.type)) {
          print('error.type -: ${error.type}');
          logger.e(error.type, tag: tag, error: error);
          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = "Request was cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription =
                  "Connection timeout, please check your internet connection";
              break;
            case DioExceptionType.unknown:
              errorDescription = "Connection failed due to internet connection";
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription = "Receive timeout in connection";
              break;
            case DioExceptionType.badCertificate:
              errorDescription =
                  "Error caused by an incorrect certificate as configured by ValidateCertificate";
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Send timeout in connection";
              break;
            case DioExceptionType.connectionError:
              errorDescription =
                  "Connection error or socket exception error in connection";
              break;
            case DioExceptionType.badResponse:
              switch (error.response?.statusCode) {
                case 404:
                  errorDescription = 'Request not found';
                  break;
                case 500:
                  errorDescription = 'Internal server error';
                  break;
                case 503:
                  errorDescription = error.response?.statusMessage;
                  break;
                default:
                  ErrorResponse errorResponse =
                      ErrorResponse.fromJson(error.response?.data);
                  if (errorResponse.errors.isNotEmpty) {
                    errorDescription = errorResponse;
                  } else {
                    errorDescription =
                        "Failed to load data - status code: ${error.response?.statusCode}";
                  }
              }
              break;
          }
        } else {
          errorDescription = "Unexpected error occurred";
        }
      } on FormatException catch (e) {
        logger.e(e.source.toString(), tag: '$tag format exception', error: e);
        errorDescription = e.message;
      } catch (e) {
        logger.e(e.toString(), tag: '$tag catch error', error: e);
        errorDescription = "Unexpected error occurred";
      }
    } else {
      errorDescription = "Unexpected error occurred";
    }
    if (showToast) {
      toast(errorDescription.toString(),
          gravity: ToastGravity.TOP, bgColor: Colors.red);
    }
    return errorDescription;
  }

  static String? findErrorMessageInData(dynamic data) {
    String? errorDescription;
    if (data == null) return null;
    print('findErrorMessageInData : ${data.runtimeType}');
    if (data is String) errorDescription = data;
    if (data is Map<String, dynamic> && data.entries.isNotEmpty) {
      errorDescription = findErrorMessageInData(data.entries.first.value);
    }
    if (data is List && data.isNotEmpty) {
      errorDescription = findErrorMessageInData(data.first);
    }
    return errorDescription;
  }

  static Future<(bool, Map<String, dynamic>, String?)> fetchData(
    String endPoint, {
    dynamic data,
    ApiMethod method = ApiMethod.POST,
  }) async {
    try {
      Response res = await (method == ApiMethod.POST
          ? dioClient.post(endPoint, data: data)
          : dioClient.get(endPoint));
      ApiResponse? apiResponse;
      try {
        apiResponse = ApiResponse.withSuccess(res);
      } catch (e) {
        apiResponse =
            ApiResponse.withError(findErrorMessageInData(res.data['data']));
      }
      if (apiResponse.response != null) {
        return (
          (apiResponse.response?.data?['status'] as bool?) ?? false,
          (apiResponse.response?.data as Map<String, dynamic>?) ?? {},
          (apiResponse.response?.data?['message'] ?? '') as String,
        );
      } else {
        return (false, <String, dynamic>{}, apiResponse.error.toString());
      }
    } catch (e) {
      return (false, <String, dynamic>{}, findErrorMessageInData(e));
    }
  }
}
