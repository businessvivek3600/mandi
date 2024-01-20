import 'package:flutter/material.dart';

import '../database/database_index.dart';
import '../utils/utils_index.dart';

class AppConst {
  static const tag = 'AppConst';
  static String appName = "NPL Mandi";
  static const String appVersion = "1.0.0";
  static const String packageName = "mandi.qbn.biz";
  static const String appStoreId = "mandi.qbn.biz/id0000000000";
  static String appDescription = "Sata King";
  static const String appIcon = "assets/images/logo-no-background.png";

  ///pusher details
  static const pusherAppId = '1648827';
  static const pusherAppKey = 'e46752839af82d018fea';
  static const pusherAppSecret = '529021ad717d16ad7c32';
  static const pusherAppCluster = 'ap2';
  static const pusherAppChatTopic = 'offer-chat-notification.';

  ///api
  static const String baseUrl = "https://mandi.qbn.biz/api/";
  static const String siteUrl = "https://mandi.qbn.biz/";
  static const String apiVersion = "v1";

  static String currencySymbol = '';
  static String defaultLanguage = 'en';

  static String testerEmail = 'demo@gmail.com';

  static Color defaultPrimaryColor = const Color(0xFF0C2139);

  static Future<void> readStringsXml() async {
    // Specify the path to strings.xml
    String xmlPath = 'android/app/src/main/res/values/strings.xml';

    try {
      var data = await loadStringXml(xmlPath);
      logger.i('readStringsXml data: $data', tag: tag);
      for (var item in data.entries.toList()) {
        switch (item.key) {
          case 'app_name':
            appName = item.value;
            break;
          case 'app_description':
            appDescription = item.value;
            break;
          case 'currency_symbol':
            currencySymbol = item.value;
            break;
          default:
            break;
        }
      }
    } catch (e) {
      logger.w('readStringsXml Error ', error: e, tag: tag);
    }
  }
}
