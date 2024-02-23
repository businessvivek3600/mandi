import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../database/database_index.dart';
import '../../constants/constants_index.dart';
import '../../utils/utils_index.dart';
import '../service_index.dart';

const String urlLaunchActionId = 'urlLaunchActionId';
const String navigationActionId = 'navigationActionId';
const String darwinNotificationCategoryPlain = 'plain';
const String darwinNotificationCategoryText = 'text';

/// ShowNotification type
enum ShowNotificationType {
  schedule,
  noSound,
  iconAction,
  textChoice,
  fullScreen,
  zonedSchedule,
  zonedScheduleAlarmClock,
  timeout,
  repeat
}

enum NotificationChannels {
  alert,
  chat,
  def,
  auction,
  promotion,
  product,
  unknown
}

enum NotificationAction {
  openChat,
  openProduct,
  openPromotion,
  openAuction,
  openUrl,
  openApp
}

/// ShowNotification
class ShowNotification {
  static const String tag = 'ShowNotification';
  static Future<void> showNotification(RemoteMessage message) async {
    pl('showNotification called ${message}');
    String channelID = '';
    String channelName = '';
    String channelDescription = '';
    String? ticker;
    String? clickAction;
    String? bigPicure;
    String? smallIcon;
    String? link;
    String? sound;
    Map<String, dynamic> payload = message.data;
    RemoteNotification? notification = message.notification;
    String? title;
    String? body;
    String? smallIconPath;
    String? bigPicturePath;
    BigPictureStyleInformation? bigPictureStyleInformation;
    BigTextStyleInformation? bigTextStyleInformation;
    late AndroidNotificationDetails androidNotificationDetails;
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
            categoryIdentifier: darwinNotificationCategoryPlain);
    const DarwinNotificationDetails macOSNotificationDetails =
        DarwinNotificationDetails(
            categoryIdentifier: darwinNotificationCategoryPlain);
    const LinuxNotificationDetails linuxNotificationDetails =
        LinuxNotificationDetails(
      actions: <LinuxNotificationAction>[
        LinuxNotificationAction(key: urlLaunchActionId, label: 'Action 1'),
        LinuxNotificationAction(key: navigationActionId, label: 'Action 2'),
      ],
    );

    logger.w('showNotification data=> ${jsonEncode(message.data)}', tag: tag);
    logger.w(
        'showNotification notification=> ${jsonEncode(message.notification?.toMap())}',
        tag: tag);

    if (notification != null) {
      title = notification.title;
      body = notification.body;
    }
    channelID = _getChannelId(payload);
    channelName = NotificationChannels.values
        .firstWhere((element) => element.id == channelID)
        .name;
    channelDescription = NotificationChannels.values
        .firstWhere((element) => element.id == channelID)
        .description;
    print(
        'channelID $channelID, channelName $channelName, channelDescription $channelDescription');
    // ticker = notification.android?.ticker ?? notification.apple?.subtitle;
    clickAction = payload['clickAction'];
    bigPicure = _getImageFromMessage(message);
    smallIcon = payload['smallIcon'];
    // link = notification.android?.link;
    // sound = notification.android?.sound ?? notification.apple?.sound?.name;
    smallIconPath = smallIcon != null
        ? await downloadAndSaveFile(smallIcon, 'smallIcon')
        : null;
    if (bigPicure != null && bigPicure.isNotEmpty) {
      try {
        bigPicturePath = await downloadAndSaveFile(bigPicure, 'bigPicture');
        bigPictureStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          hideExpandedLargeIcon: true,
          contentTitle: title,
          htmlFormatContentTitle: true,
          summaryText: body,
          htmlFormatSummaryText: true,
        );
        androidNotificationDetails = AndroidNotificationDetails(
          channelID,
          channelName,
          channelDescription: channelDescription,
          largeIcon: FilePathAndroidBitmap(smallIconPath ?? bigPicturePath),
          priority: Priority.max,
          playSound: true,
          styleInformation: bigPictureStyleInformation,
          importance: Importance.max,
          actions: [],
          // sound: RawResourceAndroidNotificationSound('notification'),
        );
      } catch (e) {
        bigTextStyleInformation = BigTextStyleInformation(
          body!,
          htmlFormatBigText: true,
          contentTitle: title,
          htmlFormatContentTitle: true,
        );
        androidNotificationDetails = AndroidNotificationDetails(
            channelID, channelName,
            channelDescription: channelDescription,
            priority: Priority.max,
            playSound: true,
            styleInformation: bigTextStyleInformation,
            importance: Importance.max,
            actions: []);
      }
    } else {
      bigTextStyleInformation = BigTextStyleInformation(
        body ?? '',
        htmlFormatBigText: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
      );
      androidNotificationDetails = AndroidNotificationDetails(
          channelID, channelName,
          channelDescription: channelDescription,
          priority: Priority.max,
          playSound: true,
          styleInformation: bigTextStyleInformation,
          importance: Importance.max,
          actions: []);
    }
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
        macOS: macOSNotificationDetails,
        linux: linuxNotificationDetails);
    if (clickAction != null && clickAction.isNotEmpty) {
      _handleNotificationAction(message, notificationDetails);
    }
    await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecond, title, body, notificationDetails,
        payload: jsonEncode(payload));
  }
/*
  /// show a notification at a particular time using the `schedule` method of the
  static Future<void> showNotificationWithActions(String title, String body,
      [String? payload]) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'NotificationWithActions',
      'NotificationWithActions',
      channelDescription: 'Direct response from notification',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          urlLaunchActionId,
          'Click to launch URL',
          icon: DrawableResourceAndroidBitmap('food'),
          contextual: true,
        ),
        AndroidNotificationAction(
          'id_2',
          'Action 2',
          titleColor: Color.fromARGB(255, 255, 0, 0),
          icon: DrawableResourceAndroidBitmap('secondary_icon'),
        ),
        AndroidNotificationAction(
          navigationActionId,
          'Action 3',
          icon: DrawableResourceAndroidBitmap('secondary_icon'),
          showsUserInterface: true,
          cancelNotification: false,
        ),
      ],
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain,
    );

    const DarwinNotificationDetails macOSNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain,
    );

    const LinuxNotificationDetails linuxNotificationDetails =
        LinuxNotificationDetails(
      actions: <LinuxNotificationAction>[
        LinuxNotificationAction(
          key: urlLaunchActionId,
          label: 'Action 1',
        ),
        LinuxNotificationAction(
          key: navigationActionId,
          label: 'Action 2',
        ),
      ],
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
      macOS: macOSNotificationDetails,
      linux: linuxNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  ///  a notification that specifies a different icon, sound and vibration pattern
  static Future<void> showNotificationWithIconAction(String title, String body,
      [String? payload]) async {
    const LinuxNotificationDetails linuxNotificationDetails =
        LinuxNotificationDetails(
      actions: <LinuxNotificationAction>[
        LinuxNotificationAction(
          key: 'media-eject',
          label: 'Eject',
        ),
      ],
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      linux: linuxNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// a notification that specifies a different icon, sound and vibration pattern
  static Future<void> showNotificationWithTextChoice(
      String title, String body, String payload) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'showNotificationWithTextChoice',
      'showNotificationWithTextChoice',
      channelDescription: 'Shows notification with text choice action',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'text_id_2',
          'Action 2',
          icon: DrawableResourceAndroidBitmap('food'),
          inputs: <AndroidNotificationActionInput>[
            AndroidNotificationActionInput(
              choices: <String>['ABC', 'DEF'],
              allowFreeFormInput: false,
            ),
          ],
          contextual: true,
        ),
      ],
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryText,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
      macOS: darwinNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// full screen notification
  static Future<void> showFullScreenNotification() async {
    var context = Get.context!;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Turn off your screen'),
        content: const Text(
            'to see the full-screen intent in 5 seconds, press OK and TURN '
            'OFF your screen'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await flutterLocalNotificationsPlugin.zonedSchedule(
                  0,
                  'scheduled title',
                  'scheduled body',
                  tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
                  const NotificationDetails(
                      android: AndroidNotificationDetails(
                          'full screen channel id', 'full screen channel name',
                          channelDescription: 'full screen channel description',
                          priority: Priority.high,
                          importance: Importance.high,
                          fullScreenIntent: true)),
                  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
                  uiLocalNotificationDateInterpretation:
                      UILocalNotificationDateInterpretation.absoluteTime);

              Navigator.pop(context);
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  /// Zoned schedule a notification that specifies different icon, sound and
  static Future<void> zonedScheduleNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  /// Zoned schedule a notification that specifies different icon, sound and
  static Future<void> zonedScheduleAlarmClockNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        123,
        'scheduled alarm clock title',
        'scheduled alarm clock body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'alarm_clock_channel', 'Alarm Clock Channel',
                channelDescription: 'Alarm Clock Notification')),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  /// show a notification with no sound
  static Future<void> showNotificationWithNoSound() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('silent channel id', 'silent channel name',
            channelDescription: 'silent channel description',
            playSound: false,
            styleInformation: DefaultStyleInformation(true, true));
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentSound: false,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
        macOS: darwinNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      '<b>silent</b> title',
      '<b>silent</b> body',
      notificationDetails,
    );
  }

  /// Time out a notification
  static Future<void> showTimeoutNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('silent channel id', 'silent channel name',
            channelDescription: 'silent channel description',
            timeoutAfter: 3000,
            styleInformation: DefaultStyleInformation(true, true));
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      'timeout notification',
      'Times out after 3 seconds',
      notificationDetails,
    );
  }

  ///periodic notification
  static Future<void> repeatNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'repeating channel id', 'repeating channel name',
            channelDescription: 'repeating description');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      DateTime.now().millisecond,
      'repeating title',
      'repeating body',
      RepeatInterval.everyMinute,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

*/
}

///handle notification action
Future<void> _handleNotificationAction(
    RemoteMessage message, NotificationDetails notificationDetails) async {
  String? clickAction = message.data['clickAction'];
  String? payload = message.data['payload'];

  //// set notification details
  if (Platform.isAndroid) {
    notificationDetails.android!.actions!.addAll([
      if (clickAction == NotificationAction.openChat.id) ...[
        _buildAndroidNotificationAction(
          NotificationAction.openChat.id,
          NotificationAction.openChat.name,
          NotificationAction.openChat.image,
        ),
      ],
      if (clickAction == NotificationAction.openProduct.id) ...[
        _buildAndroidNotificationAction(
          NotificationAction.openProduct.id,
          NotificationAction.openProduct.name,
          NotificationAction.openProduct.image,
        ),
      ],
      if (clickAction == NotificationAction.openPromotion.id) ...[
        _buildAndroidNotificationAction(
          NotificationAction.openPromotion.id,
          NotificationAction.openPromotion.name,
          NotificationAction.openPromotion.image,
        ),
      ],
      if (clickAction == NotificationAction.openAuction.id) ...[
        _buildAndroidNotificationAction(
          NotificationAction.openAuction.id,
          NotificationAction.openAuction.name,
          NotificationAction.openAuction.image,
        ),
      ],
      if (clickAction == NotificationAction.openUrl.id) ...[
        _buildAndroidNotificationAction(
          NotificationAction.openUrl.id,
          NotificationAction.openUrl.name,
          NotificationAction.openUrl.image,
        ),
      ],
      if (clickAction == NotificationAction.openApp.id) ...[
        _buildAndroidNotificationAction(
          NotificationAction.openApp.id,
          NotificationAction.openApp.name,
          NotificationAction.openApp.image,
        ),
      ],
    ]);
  }
}

/// customizedAndroidActionButtons
AndroidNotificationAction _buildAndroidNotificationAction(
    String actionId, String actionTitle,
    [String? icon, bool cancelNotification = true]) {
  return AndroidNotificationAction(
    actionId,
    actionTitle,
    icon: icon != null ? DrawableResourceAndroidBitmap(icon) : null,
    inputs: actionId == NotificationAction.openChat.id
        ? <AndroidNotificationActionInput>[
            const AndroidNotificationActionInput(
              choices: <String>['Reply', 'Reply to all', 'Forward'],
              label: 'Message',
              allowFreeFormInput: true,
              allowedMimeTypes: <String>{'app_icon.png'},
            ),
          ]
        : [],
    contextual: true,

    /// this setting customizes the action button to look like a reply button
    allowGeneratedReplies: true,
    cancelNotification: cancelNotification,
    showsUserInterface: true,
  );
}

///get image from message
String? _getImageFromMessage(RemoteMessage message) {
  String? imageUrl = (Platform.isAndroid
          ? message.notification?.android?.imageUrl
          : message.notification?.apple?.imageUrl) ??
      message.data['imageUrl'];
  return (imageUrl != null && imageUrl.isNotEmpty)
      ? imageUrl.startsWith('http') || imageUrl.startsWith('https')
          ? imageUrl
          : '${AppConst.baseUrl}/storage/app/public/notification/$imageUrl'
      : null;
}

///get channel id
String _getChannelId(Map<String, dynamic> payload) {
  String channelID = '';
  if (payload.containsKey('channelId')) {
    channelID = payload['channelId'];
  } else {
    channelID = NotificationChannels.unknown.id;
  }
  return channelID;
}

extension _MyEnumExtension on NotificationChannels {
  String get id {
    switch (this) {
      case NotificationChannels.alert:
        return 'alert';
      case NotificationChannels.chat:
        return 'chat';
      case NotificationChannels.def:
        return 'def';
      case NotificationChannels.auction:
        return 'auction';
      case NotificationChannels.promotion:
        return 'promotion';
      case NotificationChannels.product:
        return 'product';
      default:
        return 'unknown';
    }
  }

  String get name {
    switch (this) {
      case NotificationChannels.alert:
        return 'Alert';
      case NotificationChannels.chat:
        return 'Chat';
      case NotificationChannels.def:
        return 'Default';
      case NotificationChannels.auction:
        return 'Auction';
      case NotificationChannels.promotion:
        return 'Promotion';
      case NotificationChannels.product:
        return 'Product';
      default:
        return 'Unknown';
    }
  }

  String get description {
    switch (this) {
      case NotificationChannels.alert:
        return 'Alert for user';
      case NotificationChannels.chat:
        return 'Chat notification for user';
      case NotificationChannels.def:
        return 'Default notification for user';
      case NotificationChannels.auction:
        return 'Auction notification related to biddings';
      case NotificationChannels.promotion:
        return 'Promotional notification cunducted by admin';
      case NotificationChannels.product:
        return 'Product notification related to product';
      default:
        return 'Unknown notification';
    }
  }
}

///extension for NotificationAction with id, name, String? image
extension _NotificationActionExtension on NotificationAction {
  String get id {
    switch (this) {
      case NotificationAction.openChat:
        return 'openChat';
      case NotificationAction.openProduct:
        return 'openProduct';
      case NotificationAction.openPromotion:
        return 'openPromotion';
      case NotificationAction.openAuction:
        return 'openAuction';
      case NotificationAction.openUrl:
        return 'openUrl';
      case NotificationAction.openApp:
        return 'openApp';
      default:
        return 'unknown';
    }
  }

  String get name {
    switch (this) {
      case NotificationAction.openChat:
        return 'Open Chat';
      case NotificationAction.openProduct:
        return 'View Product';
      case NotificationAction.openPromotion:
        return 'View Promotion';
      case NotificationAction.openAuction:
        return 'View Auction';
      case NotificationAction.openUrl:
        return 'Open Url';
      case NotificationAction.openApp:
        return 'Open App';
      default:
        return 'Unknown';
    }
  }

  String? get image {
    switch (this) {
      case NotificationAction.openChat:
        return 'chat';
      case NotificationAction.openProduct:
        return 'product';
      case NotificationAction.openPromotion:
        return 'promotion';
      case NotificationAction.openAuction:
        return 'auction';
      case NotificationAction.openUrl:
        return 'launch_url';
      case NotificationAction.openApp:
        return 'app_icon';
      default:
        return null;
    }
  }
}
