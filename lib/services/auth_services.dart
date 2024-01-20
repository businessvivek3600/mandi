import 'package:coinxfiat/constants/constants_index.dart';
import 'package:coinxfiat/database/database_index.dart';
import 'package:nb_utils/nb_utils.dart';

import '../store/store_index.dart';
import '../utils/utils_index.dart';

class AuthService {
  static String tag = 'AuthService';

  /// login with email and password
  Future<void> login(String email, String password) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(
        ApiConst.login,
        data: {
          // "username": "sumit9451sharma@gmail.com",
          // "password": "Sumit@9451"
          "username": email,
          "password": password
        },
      );

      if (status) {
        String? token = data['data']['token'];
        print('data : token=> $token');
        if (token != null) {
          Map<String, dynamic>? user = data['data']['user'];
          if (user != null && user.isNotEmpty) {
            ///set user data
            for (var key in user.keys) {
              await setUserDataByFieldName(key, user[key]);
            }
            await appStore.setToken(token);
            dioClient.updateHeader(token);
            await appStore.setLoggedIn(true);
          }
        }
      }
      // logger.i('login status : $status $message ${appStore.isLoggedIn}',
      //     error: data, tag: tag);
    } catch (e) {
      logger.e('login error : $e', tag: tag);
    }
  }

  ///logout
  Future<bool> logout() async {
    await 3.seconds.delay;
    await appStore.setLoggedIn(false);
    // try {
    //   var (bool status, Map<String, dynamic> data, String? message) =
    //       await ApiHandler.fetchData(ApiConst.logout);
    //   if (status) {
    //     await appStore.setToken('');
    //     await appStore.setUserId(-1);
    //     await appStore.setUserName('');
    //     await appStore.setUserEmail('');
    //     await appStore.setFirstName('');
    //     await appStore.setLastName('');
    //     await appStore.setUserProfile('');
    //     await appStore.setContactNumber('');
    //     toast(message ?? 'Logout successfully',
    //         gravity: ToastGravity.TOP, bgColor: Colors.green);
    //     return true;
    //   } else {
    //     return false;
    //   }
    // } catch (e) {
    //   logger.e('logout error : $e', tag: tag);
    return true;
    // }
  }

  /// register with email and password
  Future<void> register({
    // required String firstName,
    // required String lastName,
    // required String userName,
    // required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required String phoneCode,
  }) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(
        ApiConst.register,
        data: {
          // "firstname": "Devta",
          // "lastname": "Manush",
          // "username": "DevtaManush1",
          // "password": "Manush@9451",
          // "password_confirmation": "Manush@9451",
          // "email": "DevtaMaush1@gmail.com",
          // "phone_code": "+91",
          // "phone": "7007959656",
          // "firstname": firstName,
          // "lastname": lastName,
          // "username": userName,
          "password": password,
          "password_confirmation": password,
          // "email": email,
          "phone_code": phoneCode,
          "phone": phone
        },
      );
      if (status) {
        String? token = data['data']['token'];
        print('data : token=> $token');
        if (token != null) {
          Map<String, dynamic>? user = data['data']['user'];
          if (user != null && user.isNotEmpty) {
            ///set user data
            for (var key in user.keys) {
              await setUserDataByFieldName(key, user[key]);
            }
            await appStore.setToken(token);
            dioClient.updateHeader(token);
            await appStore.setLoggedIn(true);
          }
        }
      }
      logger.i('register status : $status $message', error: data, tag: tag);
    } catch (e) {
      logger.e('register error : $e', tag: tag);
    }
  }

  ///update profile
  Future<bool> updateProfile(Map<String, dynamic> info) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(ApiConst.updateProfile,
              method: ApiMethod.POST, data: info);
      if (status) {
        Map<String, dynamic>? user = data['data']['user'];
        if (user != null && user.isNotEmpty) {
          ///set user data
          for (var key in user.keys) {
            await setUserDataByFieldName(key, user[key]);
          }
        }
        logger.i('updateProfile status : $status $message',
            error: data, tag: tag);
        return true;
      }
    } catch (e) {
      logger.e('updateProfile error : $e', tag: tag);
    }
    return false;
  }

  Future<void> setUserDataByFieldName(String fieldName, dynamic value) async {
    try {
      switch (fieldName) {
        case 'firstname':
          await appStore.setFirstName(value);
          break;
        case 'lastname':
          await appStore.setLastName(value);
          break;
        case 'username':
          await appStore.setUserName(value);
          break;
        case 'email':
          await appStore.setUserEmail(value);
          break;
        case 'id':
          await appStore.setUserId(value);
          break;
        case 'phone_code':
          await appStore.setPhoneCode(value);
          break;
        case 'phone':
          await appStore.setContactNumber(value);
          break;
        case 'image':
          await appStore.setUserProfile(value ?? '');
          break;
        case 'address':
          await appStore.setAddress(value ?? '');
          break;
        default:
          break;
      }
    } catch (e) {
      logger.e('setUserByFieldName error on $fieldName $value : $e', tag: tag);
    }
  }

  ///getUserByToken
  Future<void> getUserByToken() async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(ApiConst.getUser, method: ApiMethod.GET);
      if (status) {
        Map<String, dynamic>? user = data['data']?['user'];
        if (user != null && user.isNotEmpty) {
          ///set user data
          for (var key in user.keys) {
            await setUserDataByFieldName(key, user[key]);
          }
        }
      }
      logger.i('getUserByToken status : $status $message',
          error: data, tag: tag);
    } catch (e) {
      logger.e('getUserByToken error : $e', tag: tag);
    }
  }

  ///update password
  Future<bool> updatePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(ApiConst.updatePassword,
              method: ApiMethod.POST,
              data: {
            'current_password': currentPassword,
            'password': newPassword,
            'password_confirmation': confirmPassword
          });
      if (status) {
        logger.i('updatePassword status : $status $message',
            error: data, tag: tag);
        return true;
      }
    } catch (e) {
      logger.e('updatePassword error : $e', tag: tag);
    }
    return false;
  }
}
