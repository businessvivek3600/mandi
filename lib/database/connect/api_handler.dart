// import '/constants/constants_index.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';

// import '../../app/modules/auth/controllers/auth_controller.dart';
// import '../../app/modules/auth/user_model.dart';
// import '../../app/routes/app_pages.dart';
// import '../../services/auth_services.dart';
// import '../../utils/utils_index.dart';
// import 'base_connect.dart';

// class ApiHandler {
//   static const tag = 'ApiHandler';
//   static String? getReasonMessage(dynamic data) {
//     try {
//       if (data is String) {
//         return data;
//       } else if (data is Map) {
//         return getReasonMessage(data.entries.first.value);
//       } else if (data is List) {
//         return getReasonMessage(data.first);
//       }
//     } catch (e) {
//       logger.e('getReasonMessage Error', tag: tag, error: e);
//       return null;
//     }
//     return null;
//   }

//   static final baseConnect = Get.put(BaseConnect());

//   static Future<Map<String, dynamic>?> hitApi(
//     endPoint, {
//     dynamic body,
//     isFormData = false,
//     ApiMethod method = ApiMethod.POST,
//     bool token = true,
//     Map<String, dynamic>? query,
//   }) async {
//     try {
//       if (isFormData) {
//         body = FormData(body);
//       }
//       final response = method == ApiMethod.POST
//           ? await baseConnect.post(endPoint, body, query: query)
//           : await baseConnect.get(endPoint, query: query);
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         await updateUser(response.body['user'], endPoint);
//         return response.body;
//       } else {}
//     } catch (e) {
//       logger.e('hitApi Error', tag: tag, error: e);
//     }
//     return null;
//   }

//   /// update user in local storage
//   static Future<void> updateUser(dynamic user, String endPoint) async {
//     try {
//       if (user != null) {
//         var newUser = AuctionUser.fromJson(user);
//         Get.put(AuthController());
//         Get.find<AuthController>().setCurrentUser(newUser);
//       }
//     } catch (e) {
//       logger.e('updateUser Error', tag: tag, error: e);
//     }
//   }

//   /// check if logout
//   static Future<void> checkIfLogin(dynamic data, String endPoint) async {
//     if (data == 1 || data == '1') {
//       var auth = AuthService.instance;

//       ///logout()
//       if (auth.runningLogOut) return;
//       showGeneralDialog(
//         context: Get.context!,
//         pageBuilder: (context, animation, secondaryAnimation) {
//           return const AlertDialog(
//             title: Text('Session Expired'),
//             content: Row(
//               children: [
//                 CircularProgressIndicator.adaptive(),
//                 SizedBox(width: 10),
//                 Expanded(
//                     child: Text('Please login again to continue',
//                         textAlign: TextAlign.start)),
//               ],
//             ),
//           );
//         },
//       );
//       logger.w('user logged out Reason: # $endPoint', tag: tag);
//       await Future.delayed(const Duration(seconds: 3))
//           .then((value) async => await auth.logout())
//           .then((value) => (Get.context?.canPop() ?? false) ? Get.back() : null)
//           .then((value) => Get.context?.go(Routes.auth));
//     }
//   }

//   static bool checkApiSuccess(Map<String, dynamic>? data,
//       [bool showSuccessMessage = false]) {
//     if (data != null) {
//       if (data['status'] != null && data['status']) {
//         if (showSuccessMessage) {
//           var successMessage =
//               ApiHandler.getReasonMessage(data['message']['success']);
//           if (successMessage != null) {
//             successSnack(message: successMessage, context: Get.context!);
//           }
//         }
//         return true;
//       } else {
//         var message = ApiHandler.getReasonMessage(data['message']['error']);
//         if (message != null) {
//           errorSnack(message: message, context: Get.context!);
//         }
//         return false;
//       }
//     }
//     return false;
//   }
// }
