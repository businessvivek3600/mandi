import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/utils_index.dart';
import 'show_notification.dart';

/// flutterLocalNotificationsPlugin instance
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<Map<String, dynamic>?> selectNotificationStream =
    StreamController<Map<String, dynamic>?>.broadcast();

/// Initializes the notification plugin and registers notification actions
class NotificationSetup {
  static const String tag = "NotificationSetup";

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  static Future<void> initialize() async => await initNotification();

  static Future<void> initFCM([bool fromBg = false]) async {
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      var tag = 'FirebaseMessaging ';
      pl('initFCM getInitialMessage ${fromBg ? 'from bg' : ''}: $value', tag);
      if (value != null) selectNotificationStream.add(value.data);
    });

    ///onMessage
    FirebaseMessaging.onMessage.listen((message) {
      pl('initFCM onMessage ${fromBg ? 'from bg' : ''}: $message');
      var tag = 'FirebaseMessaging';
      logger.i('onMessage', error: message.toMap(), tag: tag);
      ShowNotification.showNotification(message);
    },
        onDone: () => logger.i('onMessage done', tag: tag),
        onError: (e) => logger.e('onMessage', error: e, tag: tag));

    /// onMessageOpenedApp
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      var tag = 'FirebaseMessaging';
      logger.i('onMessageOpenedApp', error: message.toMap(), tag: tag);
      selectNotificationStream.add(message.data);
    },
        onDone: () => logger.i('onMessageOpenedApp done'),
        onError: (e) => logger.e('onMessageOpenedApp', error: e, tag: tag));
  }
}

///handle notifications
class HandleNotification {
  static void handleNotification(String? payload) {
    if (payload != null) {
      log('notification payload: $payload');
    }
  }

  static void configureSelectNotificationSubject() {
    selectNotificationStream.stream
        .listen((Map<String, dynamic>? payload) async {
      logger.w('configureSelectNotificationSubject payload: $payload');
      try {
        if (payload != null) {}
      } catch (e) {
        logger.e('configureSelectNotificationSubject error: $e');
      }
    });
  }

  static void configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) async {});
  }

  static void dispose() {
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
  }
}

/// setup the notification plugin
Future<void> initNotification() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  await _configureLocalTimeZone();
  await _requestPermissions();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
}

///request permission
Future<void> _requestPermissions() async {
  ///check request permission
  await Permission.notification
      .onDeniedCallback(() {
        logger.w('Permission.notification.onDeniedCallback');
        _permissionForNotification();
      })
      .onGrantedCallback(() {
        logger.w('Permission.notification.onGrantedCallback');
      })
      .onPermanentlyDeniedCallback(() {
        logger.w('Permission.notification.onPermanentlyDeniedCallback');
        _permissionForNotification();
      })
      .onRestrictedCallback(() {
        logger.w('Permission.notification.onRestrictedCallback');
        _permissionForNotification();
      })
      .onLimitedCallback(() {
        logger.w('Permission.notification.onLimitedCallback');
        _permissionForNotification();
      })
      .onProvisionalCallback(() {
        logger.w('Permission.notification.onProvisionalCallback');
        _permissionForNotification();
      })
      .request()
      .then((value) => logger.i('Permission.notification.request: $value'));
}

void _permissionForNotification() async {
  if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();
  }
}

///configure local timezone
Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || defaultTargetPlatform == TargetPlatform.linux) return;
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

/// payload from notification
Future<Map<String, dynamic>?> _getPayloadMap(dynamic payload) async {
  try {
    if (payload != null) {
      Map<String, dynamic> payloadMap = {};
      try {
        payloadMap = jsonDecode(payload);
      } catch (e) {
        payloadMap.addAll({'payloadString': payload});
      }
      return payloadMap;
    }
    return null;
  } catch (e) {
    logger.e('getPayload error: $e');
    return null;
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

///For notification actions that don't show the application/user interface, the [onDidReceiveBackgroundNotificationResponse] callback is invoked on a background isolate
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  var tag = 'notificationTapBackground';
  logger.w('Notification Response',
      error: notificationResponse.payload, tag: tag);
  onDidReceiveNotificationResponse(notificationResponse);
}

/// firebaseMessagingBackgroundHandler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  var tag = 'firebaseMessagingBackgroundHandler';
  // await initBeforeRun(true);
  // ShowNotification.showNotification(message);
  logger.i('firebaseMessagingBackgroundHandler',
      error: message.toMap(), tag: tag);
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  var tag = 'onDidReceiveNotificationResponse';
  logger.i(
      '${notificationResponse.id} ${notificationResponse.notificationResponseType.name}',
      error: notificationResponse.actionId,
      tag: tag);
  switch (notificationResponse.notificationResponseType) {
    case NotificationResponseType.selectedNotification:
      selectNotificationStream
          .add(await _getPayloadMap(notificationResponse.payload ?? ''));
      break;
    case NotificationResponseType.selectedNotificationAction:
      var payload = jsonDecode(notificationResponse.payload ?? '{}');

      break;
  }
}
