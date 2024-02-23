import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/constants_index.dart';

class AppShare {
  static String playStoreLink =
      "https://play.google.com/store/apps/details?id=${AppConst.packageName}";
  static String appstoreLink =
      "https://apps.apple.com/us/app/${AppConst.appStoreId}";
  static String appShareText =
      "Download this app from\n   Playstore: $playStoreLink\n\n   Appstore: $appstoreLink";
  static String appShareSubject =
      "${AppConst.appName} - ${AppConst.appDescription}";

  static getRefferalLink(String? username) =>
      username != null && username.isNotEmpty
          ? "Click on my refferal link ${AppConst.siteUrl}/register/$username"
          : '';

  static Future<void> shareGame({
    required String gameName,
    required String gameTiming,
    required String today,
    required String yesterday,
    required List<String> list,
  }) async {
    String message = """🔊🔊🔊
$gameName News Update
🗓️ Date: $gameTiming
👉🏻 Today's News: $today
👉🏻 Yesterday's News: $yesterday

📲 For news updates and free single-digit predictions for ${lastItemWithAnd(list)}, download the app now: $playStoreLink

Feel free to share this information with others! 🌐""";

    await Share.share(message, subject: appShareSubject);
  }

  static Future<void> shareApp({
    required List<String> list,
  }) async {
    String message = """🔊🔊🔊
📲 For news updates and free single-digit predictions for ${lastItemWithAnd(list)}, download the app now: $playStoreLink

Feel free to share this information with others! 🌐""";

    await Share.share(message, subject: appShareSubject);
  }

  static Future<void> shareAnAuctionWithImage(String imagePath) async {
    // await Share.shareFiles([imagePath], text: appLink, subject: appShareSubject);
  }

  static String lastItemWithAnd(
    List<String> items,
  ) {
    String result = items.asMap().entries.map((entry) {
      int index = entry.key;
      String item = entry.value;

      if (index == items.length - 2) {
        return '$item and ';
      } else if (index == items.length - 1) {
        return item;
      } else {
        return '$item, ';
      }
    }).join();

    return result;
  }

  ///rate app
  static Future<void> rateApp() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      final appId = defaultTargetPlatform == TargetPlatform.android
          ? AppConst.packageName
          : AppConst.appStoreId;
      final url = Uri.parse(
        defaultTargetPlatform == TargetPlatform.android
            ? "market://details?id=$appId"
            : "https://apps.apple.com/app/id$appId",
      );
      launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
