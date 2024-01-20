// // base connect from get connect with error handling

// import '/database/connect/api_handler.dart';

// import '../../app/modules/auth/providers/user_provider.dart';
// import '/constants/constants_index.dart';
// import 'package:flutter/material.dart';
// import '../../../utils/utils_index.dart';
// import 'package:get/get.dart';

// class BaseConnect extends GetConnect {
//   static const tag = 'BaseConnect';
//   @override
//   void onInit() {
//     httpClient.baseUrl = ApiConst.baseUrl;
//     httpClient.timeout = const Duration(seconds: 30);

//     ///request modifier
//     httpClient.addRequestModifier<dynamic>((request) {
//       logger.d('On Request ',
//           tag: '${request.url} $tag', error: '${request.headers}');

//       ///add current time to header
//       request.headers['time'] =
//           DateTime.now().millisecondsSinceEpoch.toString();
//       return request;
//     });

//     ///response modifier
//     httpClient.addResponseModifier<dynamic>((request, response) async {
//       ///get current time from header
//       var time = request.headers['time'] ?? '0';
//       var diff = DateTime.now().millisecondsSinceEpoch - int.parse(time);

//       logger.t('On Response',
//           tag: '${request.url} ${response.statusCode} ${diff}ms $tag',
//           error: response.body);
//       if (response.body is Map) {
//         await ApiHandler.checkIfLogin(
//             response.body['is_logged_out'], request.url.path);
//       }
//       print('response.statusCode ${response.statusCode}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return response;
//       } else {
//         return errorHandler(response);
//       }
//     });

//     ///authenticator
//     httpClient.addAuthenticator<dynamic>((request) async {
//       // request.headers['Authorization'] =
//       //     'Bearer ${UserProvider.instance.getToken ?? ''}';
//       // logger.d('On Authenticator ',
//       //     tag: '${request.url} $tag', error: '${request.headers}');
//       return request;
//     });
//   }

//   @override
//   Future<Response<T>> post<T>(
//     String? url,
//     body, {
//     FormData? form,
//     bool token = true,
//     String? contentType,
//     Map<String, String>? headers,
//     Map<String, dynamic>? query,
//     Decoder<T>? decoder,
//     Progress? uploadProgress,
//   }) async {
//     body = body ?? form;
//     contentType = form != null ? 'multipart/form-data' : null;
//     logger.d('Request-data:', tag: '$url $tag', error: ' $body ');
//     if (token) {
//       updateToken((await UserProvider.instance).getToken ?? '');
//     }

//     return super.post(
//       url,
//       body,
//       contentType: contentType,
//       headers: headers,
//       query: query,
//       decoder: decoder,
//       uploadProgress: uploadProgress,
//     );
//   }

//   @override
//   Future<Response<T>> get<T>(String url,
//       {Map<String, String>? headers,
//       bool token = true,
//       String? contentType,
//       Map<String, dynamic>? query,
//       Decoder<T>? decoder}) async {
//     if (token) {
//       updateToken((await UserProvider.instance).getToken ?? '');
//     }
//     //3QWY3qcsd4dfUNg3tdLZOMtK6KpJISAdGOF1xzvb
//     return super.get(url,
//         headers: headers,
//         contentType: contentType,
//         query: query,
//         decoder: decoder);
//   }

//   Future<void> updateHeader(Map<String, dynamic> header) async {
//     httpClient.addRequestModifier<dynamic>((request) {
//       for (var element in header.entries) {
//         request.headers[element.key] = element.value;
//       }
//       return request;
//     });
//   }

//   /// update token
//   Future<void> updateToken(String token) async {
//     logger.w('updateToken: $token', tag: tag);
//     httpClient.addRequestModifier<dynamic>((request) {
//       request.headers['Authorization'] = 'Bearer $token';
//       return request;
//     });
//   }

//   /// remove authrization
//   // Future<void> removeAuthorization() async {
//   //   httpClient.addRequestModifier<dynamic>((request) {
//   //     request.headers.remove('Authorization');
//   //     return request;
//   //   });
//   // }
// }

// Response errorHandler(Response response) {
//   String message = '';
//   try {
//     switch (response.statusCode) {
//       case 200:
//         logger.t('response success',
//             tag: 'errorHandler', error: response.statusCode);
//       case 201:
//         logger.t('response success',
//             tag: 'errorHandler', error: response.statusCode);
//       case 202:
//         message = response.body['message'];
//         break;

//       case 500:
//         message = 'Internal server error';
//         break;
//       case 403:
//         message = 'Check your internet connection or try again';
//         break;
//       case 404:
//         message = 'Request not found';
//         break;
//       case 400:
//         message = 'Bad request';
//         break;
//       case 401:
//         message = 'You are not authorized';
//         break;
//       default:
//         message = 'Something went wrong';
//         break;
//     }
//     if (message.isNotEmpty) {
//       Get.snackbar('Error', message,
//           backgroundColor: Colors.red,
//           titleText: const Text('Error', style: TextStyle(color: Colors.white)),
//           messageText:
//               Text(message, style: const TextStyle(color: Colors.white)));
//     }
//   } catch (e) {
//     logger.e('errorHandler error: ', tag: 'errorHandler', error: e);
//   }
//   return response;
// }
