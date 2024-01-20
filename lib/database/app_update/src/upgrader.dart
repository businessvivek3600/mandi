/*
 * Copyright (c) 2018-2023 Larry Aasen. All rights reserved.
 */

import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/utils_index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

import 'appcast.dart';
import 'itunes_search_api.dart';
import 'play_store_search_api.dart';
import 'upgrade_os.dart';
import 'upgrade_messages.dart';

String? appVersion;
typedef BoolCallback = bool Function();
typedef VoidBoolCallback = void Function(bool value);
typedef WillDisplayUpgradeCallback = void Function(
    {required bool display,
    String? minAppVersion,
    String? installedVersion,
    String? appStoreVersion});
typedef UpgraderEvaluateNeed = bool;

enum UpgradeDialogStyle { cupertino, material }

class AppcastConfiguration {
  final List<String>? supportedOS;
  final String? url;

  AppcastConfiguration({this.supportedOS, this.url});
}

Upgrader _sharedInstance = Upgrader();

class Upgrader with WidgetsBindingObserver {
  final Appcast? appcast;
  final AppcastConfiguration? appcastConfig;
  bool canDismissDialog;
  final http.Client client;
  final String? countryCode;
  final String? languageCode;
  bool debugDisplayAlways;
  bool debugDisplayOnce;
  bool debugLogging;
  UpgradeDialogStyle dialogStyle;
  final Duration durationUntilAlertAgain;
  UpgraderMessages messages;
  String? minAppVersion;
  BoolCallback? onIgnore;
  BoolCallback? onLater;
  BoolCallback? onUpdate;
  BoolCallback? shouldPopScope;
  bool showIgnore;
  bool showLater;
  bool showReleaseNotes;
  TextStyle? cupertinoButtonTextStyle;
  WillDisplayUpgradeCallback? willDisplayUpgrade;
  final UpgraderOS upgraderOS;

  bool _displayed = false;
  bool _initCalled = false;
  PackageInfo? _packageInfo;

  String? _installedVersion;
  String? _appStoreVersion;
  String? _appStoreListingURL;
  String? _releaseNotes;
  String? _updateAvailable;
  DateTime? _lastTimeAlerted;
  String? _lastVersionAlerted;
  String? _userIgnoredVersion;
  bool _hasAlerted = false;
  bool _isCriticalUpdate = false;

  double borderRadius;
  double elevation;
  double padding;
  Color textColor;
  Color backgroundColor;
  Future<bool>? _futureInit;
  Stream<UpgraderEvaluateNeed> get evaluationStream => _streamController.stream;
  final _streamController = StreamController<UpgraderEvaluateNeed>.broadcast();
  bool get evaluationReady => _evaluationReady;
  bool _evaluationReady = false;

  final notInitializedExceptionMessage =
      'initialize() not called. Must be called first.';

  Upgrader({
    this.appcastConfig,
    this.appcast,
    UpgraderMessages? messages,
    this.debugDisplayAlways = false,
    this.debugDisplayOnce = false,
    this.debugLogging = false,
    this.durationUntilAlertAgain = const Duration(days: 3),
    this.onIgnore,
    this.onLater,
    this.onUpdate,
    this.shouldPopScope,
    this.willDisplayUpgrade,
    http.Client? client,
    this.showIgnore = true,
    this.showLater = true,
    this.showReleaseNotes = true,
    this.canDismissDialog = false,
    this.countryCode,
    this.languageCode,
    this.minAppVersion,
    this.dialogStyle = UpgradeDialogStyle.material,
    this.cupertinoButtonTextStyle,
    this.borderRadius = 10.0,
    this.elevation = 24.0,
    this.padding = 24.0,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.white,
    UpgraderOS? upgraderOS,
  })  : client = client ?? http.Client(),
        messages = messages ?? UpgraderMessages(),
        upgraderOS = upgraderOS ?? UpgraderOS() {
    if (debugLogging) log("upgrader: instantiated.");
  }
  static Upgrader get sharedInstance => _sharedInstance;

  void installPackageInfo({PackageInfo? packageInfo}) {
    _packageInfo = packageInfo;
    _initCalled = false;
  }

  void installAppStoreVersion(String version) {
    _appStoreVersion = version;
  }

  void installAppStoreListingURL(String url) {
    _appStoreListingURL = url;
  }

  Future<bool> initialize() async {
    if (debugLogging) {
      log('upgrader: initialize called');
    }
    if (_futureInit != null) return _futureInit!;

    _futureInit = Future(() async {
      if (debugLogging) {
        log('upgrader: initializing');
      }
      if (_initCalled) {
        assert(false, 'This should never happen.');
        return true;
      }
      _initCalled = true;

      if (messages.languageCode.isEmpty) {
        log('upgrader: error -> languageCode is empty');
      } else if (debugLogging) {
        log('upgrader: languageCode: ${messages.languageCode}');
      }

      await _getSavedPrefs();

      if (debugLogging) {
        log('upgrader: default operatingSystem: '
            '${upgraderOS.operatingSystem} ${upgraderOS.operatingSystemVersion}');
        log('upgrader: operatingSystem: ${upgraderOS.operatingSystem}');
        log('upgrader: '
            'isAndroid: ${upgraderOS.isAndroid}, '
            'isIOS: ${upgraderOS.isIOS}, '
            'isLinux: ${upgraderOS.isLinux}, '
            'isMacOS: ${upgraderOS.isMacOS}, '
            'isWindows: ${upgraderOS.isWindows}, '
            'isFuchsia: ${upgraderOS.isFuchsia}, '
            'isWeb: ${upgraderOS.isWeb}');
      }

      if (_packageInfo == null) {
        // _packageInfo = await PackageInfo(
        //   appName: 'appName',
        //   packageName: 'com.mywealthclub',
        //   version: '0.0.0',
        //   buildNumber: '0',
        // );
        _packageInfo = await PackageInfo.fromPlatform();
        if (debugLogging) {
          log('upgrader: package info packageName: ${_packageInfo!.packageName}');
          log('upgrader: package info appName: ${_packageInfo!.appName}');
          log('upgrader: package info version: ${_packageInfo!.version}');
        }
        appVersion = _packageInfo!.version;
      }

      _installedVersion = _packageInfo!.version;
      await _updateVersionInfo();
      WidgetsBinding.instance.addObserver(this);
      _evaluationReady = true;
      _streamController.add(true);

      return true;
    });
    return _futureInit!;
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      await _updateVersionInfo();
      _streamController.add(true);
    }
  }

  Future<bool> _updateVersionInfo() async {
    if (_isAppcastThisPlatform()) {
      if (debugLogging) {
        log('upgrader: appcast is available for this platform');
      }

      final appcast = this.appcast ?? Appcast(client: client);
      await appcast.parseAppcastItemsFromUri(appcastConfig!.url!);
      if (debugLogging) {
        var count = appcast.items == null ? 0 : appcast.items!.length;
        log('upgrader: appcast item count: $count');
      }
      final criticalUpdateItem = appcast.bestCriticalItem();
      final criticalVersion = criticalUpdateItem?.versionString ?? '';

      final bestItem = appcast.bestItem();
      if (bestItem != null &&
          bestItem.versionString != null &&
          bestItem.versionString!.isNotEmpty) {
        if (debugLogging) {
          log('upgrader: appcast best item version: ${bestItem.versionString}');
          log('upgrader: appcast critical update item version: ${criticalUpdateItem?.versionString}');
        }

        try {
          if (criticalVersion.isNotEmpty &&
              Version.parse(_installedVersion!) <
                  Version.parse(criticalVersion)) {
            _isCriticalUpdate = true;
          }
        } catch (e) {
          log('upgrader: updateVersionInfo could not parse version info $e');
          _isCriticalUpdate = false;
        }

        _appStoreVersion = bestItem.versionString;
        _appStoreListingURL = bestItem.fileURL;
        _releaseNotes = bestItem.itemDescription;
      }
    } else {
      if (_packageInfo == null || _packageInfo!.packageName.isEmpty) {
        return false;
      }

      // The  country code of the locale, defaulting to `US`.
      final country = countryCode ?? findCountryCode();
      if (debugLogging) {
        log('upgrader: countryCode: $country');
      }

      // The  language code of the locale, defaulting to `en`.
      final language = languageCode ?? findLanguageCode();
      if (debugLogging) {
        log('upgrader: languageCode: $language');
      }

      // Get Android version from Google Play Store, or
      // get iOS version from iTunes Store.
      if (upgraderOS.isAndroid) {
        await _getAndroidStoreVersion(country: country, language: language);
      } else if (upgraderOS.isIOS) {
        final iTunes = ITunesSearchAPI();
        iTunes.debugLogging = debugLogging;
        iTunes.client = client;
        final response = await (iTunes
            .lookupByBundleId(_packageInfo!.packageName, country: country));

        if (response != null) {
          _appStoreVersion = iTunes.version(response);
          _appStoreListingURL = iTunes.trackViewUrl(response);
          _releaseNotes ??= iTunes.releaseNotes(response);
          final mav = iTunes.minAppVersion(response);
          if (mav != null) {
            minAppVersion = mav.toString();
            if (debugLogging) {
              log('upgrader: ITunesResults.minAppVersion: $minAppVersion');
            }
          }
        }
      }
    }

    return true;
  }

  Future<bool?> _getAndroidStoreVersion(
      {String? country, String? language}) async {
    final id = _packageInfo!.packageName;
    final playStore = PlayStoreSearchAPI(client: client);
    playStore.debugLogging = debugLogging;
    final response =
        await (playStore.lookupById(id, country: country, language: language));
    if (response != null) {
      _appStoreVersion ??= playStore.version(response);
      _appStoreListingURL ??=
          playStore.lookupURLById(id, language: language, country: country);
      _releaseNotes ??= playStore.releaseNotes(response);
      final mav = playStore.minAppVersion(response);
      if (mav != null) {
        minAppVersion = mav.toString();
        if (debugLogging) {
          log('upgrader: PlayStoreResults.minAppVersion: $minAppVersion');
        }
      }
    }

    return true;
  }

  bool _isAppcastThisPlatform() {
    if (appcastConfig == null ||
        appcastConfig!.url == null ||
        appcastConfig!.url!.isEmpty) {
      return false;
    }
    var supported = true;
    if (appcastConfig!.supportedOS != null) {
      supported =
          appcastConfig!.supportedOS!.contains(upgraderOS.operatingSystem);
    }
    return supported;
  }

  bool _verifyInit() {
    if (!_initCalled) {
      throw (notInitializedExceptionMessage);
    }
    return true;
  }

  String appName() {
    _verifyInit();
    return _packageInfo?.appName ?? '';
  }

  String? currentAppStoreListingURL() => _appStoreListingURL;

  String? currentAppStoreVersion() => _appStoreVersion;

  String? currentInstalledVersion() => _installedVersion;

  String? get releaseNotes => _releaseNotes;

  String message() {
    var msg = messages.message(UpgraderMessage.body)!;
    msg = msg.replaceAll('{{appName}}', appName());
    msg = msg.replaceAll(
        '{{currentAppStoreVersion}}', currentAppStoreVersion() ?? '');
    msg = msg.replaceAll(
        '{{currentInstalledVersion}}', currentInstalledVersion() ?? '');
    return msg;
  }

  void checkVersion({required BuildContext context}) {
    if (!_displayed) {
      final shouldDisplay = shouldDisplayUpgrade();
      if (debugLogging) {
        log('upgrader: shouldDisplayReleaseNotes: ${shouldDisplayReleaseNotes()}');
      }
      if (shouldDisplay) {
        _displayed = true;
        Future.delayed(const Duration(milliseconds: 0), () {
          _showDialog(
            version: Version.parse(_appStoreVersion!),
            context: context,
            title: messages.message(UpgraderMessage.title),
            message: message(),
            releaseNotes: shouldDisplayReleaseNotes() ? _releaseNotes : null,
            canDismissDialog: canDismissDialog,
          );
        });
      }
    }
  }

  bool blocked() {
    return belowMinAppVersion() || _isCriticalUpdate;
  }

  bool shouldDisplayUpgrade() {
    final isBlocked = blocked();
    log('upgrader: shouldDisplayUpgrade: isBlocked $isBlocked');
    if (debugLogging) {
      log('upgrader: blocked: $isBlocked');
      log('upgrader: debugDisplayAlways: $debugDisplayAlways');
      log('upgrader: debugDisplayOnce: $debugDisplayOnce');
      log('upgrader: hasAlerted: $_hasAlerted');
    }

    // If installed version is below minimum app version, or is a critical update,
    // disable ignore and later buttons.
    if (isBlocked) {
      showIgnore = false;
      showLater = false;
    }
    bool rv = true;
    if (debugDisplayAlways || (debugDisplayOnce && !_hasAlerted)) {
      log('upgrader: shouldDisplayUpgrade: debugDisplayAlways: $rv');
      rv = true;
    } else if (!isUpdateAvailable()) {
      rv = false;
    } else if (isBlocked) {
      rv = true;
    } else if (isTooSoon() || alreadyIgnoredThisVersion()) {
      rv = false;
    }
    if (debugLogging) {
      log('upgrader: shouldDisplayUpgrade: $rv');
    }

    // Call the [willDisplayUpgrade] callback when available.
    if (willDisplayUpgrade != null) {
      willDisplayUpgrade!(
          display: rv,
          minAppVersion: minAppVersion,
          installedVersion: _installedVersion,
          appStoreVersion: _appStoreVersion);
    }

    return rv;
  }

  bool belowMinAppVersion() {
    var rv = false;
    if (minAppVersion != null) {
      try {
        final minVersion = Version.parse(minAppVersion!);
        final installedVersion = Version.parse(_installedVersion!);
        rv = installedVersion < minVersion;
      } catch (e) {
        if (debugLogging) {
          log(e.toString());
        }
      }
    }
    return rv;
  }

  bool isTooSoon() {
    if (_lastTimeAlerted == null) {
      return false;
    }

    final lastAlertedDuration = DateTime.now().difference(_lastTimeAlerted!);
    final rv = lastAlertedDuration < durationUntilAlertAgain;
    if (rv && debugLogging) {
      log('upgrader: isTooSoon: true');
    }
    return rv;
  }

  bool alreadyIgnoredThisVersion() {
    final rv =
        _userIgnoredVersion != null && _userIgnoredVersion == _appStoreVersion;
    if (rv && debugLogging) {
      log('upgrader: alreadyIgnoredThisVersion: true');
    }
    return rv;
  }

  bool isUpdateAvailable() {
    log('upgrader: isUpdateAvailable: checking...');
    if (debugLogging) {
      log('upgrader: appStoreVersion: $_appStoreVersion');
      log('upgrader: installedVersion: $_installedVersion');
      log('upgrader: minAppVersion: $minAppVersion');
    }
    if (_appStoreVersion == null || _installedVersion == null) {
      if (debugLogging) log('upgrader: isUpdateAvailable: false');
      return false;
    }

    try {
      final appStoreVersion = Version.parse(_appStoreVersion!);
      final installedVersion = Version.parse(_installedVersion!);
      final available = compareVersion(appStoreVersion, installedVersion) > 0;
      log('upgrader: isUpdateAvailable: appStore-version $appStoreVersion installedVersion $installedVersion res:-> ${installedVersion.compareTo(appStoreVersion)}');
      log(
        'appStoreVersion a.major = ${appStoreVersion.major} min: ${appStoreVersion.minor} patch:  ${appStoreVersion.patch} preRelease: ${appStoreVersion.preRelease} build: ${appStoreVersion.build}',
      );
      log(
        'installedVersion b.major = ${installedVersion.major} min: ${installedVersion.minor} patch:  ${installedVersion.patch} preRelease: ${installedVersion.preRelease} build: ${installedVersion.build}',
      );
      _updateAvailable = available ? _appStoreVersion : null;
    } on Exception catch (e) {
      if (debugLogging) {
        ;
        logger.e('upgrader: isUpdateAvailable: $e');
      }
    }
    final isAvailable = _updateAvailable != null;
    if (debugLogging) log('upgrader: isUpdateAvailable: $isAvailable');
    return isAvailable;
  }

  int compareVersion(Version? a, Version? b) {
    if (a == null) {
      throw ArgumentError.notNull("a");
    }

    if (b == null) {
      throw ArgumentError.notNull("b");
    }
    return a.compareTo(b);
    pl('a: $a b: $b');
    if (a.major > b.major) return 1;
    if (a.major < b.major) return -1;

    if (a.minor > b.minor) return 1;
    if (a.minor < b.minor) return -1;

    if (a.patch > b.patch) return 1;
    if (a.patch < b.patch) return -1;

    if (a.build.compareTo(b.build) == 1) return 1;
    if (a.build.compareTo(b.build) == -1) return 1;

    // if (a.preRelease.isEmpty) {
    //   if (b.preRelease.isEmpty) {
    //     return 0;
    //   } else {
    //     return 1;
    //   }
    // } else if (b.preRelease.isEmpty) {
    //   return -1;
    // } else {
    //   int preReleaseMax = a.preRelease.length;
    //   if (b.preRelease.length > a.preRelease.length) {
    //     preReleaseMax = b.preRelease.length;
    //   }
    //
    //   for (int i = 0; i < preReleaseMax; i++) {
    //     if (b.preRelease.length <= i) {
    //       return 1;
    //     } else if (a.preRelease.length <= i) {
    //       return -1;
    //     }
    //
    //     if (a.preRelease[i] == b.preRelease[i]) continue;
    //
    //     final bool aNumeric = _isNumeric(a.preRelease[i]);
    //     final bool bNumeric = _isNumeric(b.preRelease[i]);
    //
    //     if (aNumeric && bNumeric) {
    //       final double aNumber = double.parse(a.preRelease[i]);
    //       final double bNumber = double.parse(b.preRelease[i]);
    //       if (aNumber > bNumber) {
    //         return 1;
    //       } else {
    //         return -1;
    //       }
    //     } else if (bNumeric) {
    //       return 1;
    //     } else if (aNumeric) {
    //       return -1;
    //     } else {
    //       return a.preRelease[i].compareTo(b.preRelease[i]);
    //     }
    //   }
    // }
    return 0;
  }

  bool shouldDisplayReleaseNotes() {
    return showReleaseNotes && (_releaseNotes?.isNotEmpty ?? false);
  }

  String? findCountryCode({BuildContext? context}) {
    Locale? locale;
    if (context != null) {
      locale = Localizations.maybeLocaleOf(context);
    } else {
      // Get the system locale
      locale = PlatformDispatcher.instance.locale;
    }
    final code = locale == null || locale.countryCode == null
        ? 'US'
        : locale.countryCode;
    return code;
  }

  String? findLanguageCode({BuildContext? context}) {
    Locale? locale;
    if (context != null) {
      locale = Localizations.maybeLocaleOf(context);
    } else {
      // Get the system locale
      locale = PlatformDispatcher.instance.locale;
    }
    final code = locale == null ? 'en' : locale.languageCode;
    return code;
  }

  void _showDialog({
    required Version version,
    required BuildContext context,
    required String? title,
    required String message,
    required String? releaseNotes,
    required bool canDismissDialog,
  }) {
    if (debugLogging) {
      log('upgrader: showDialog title: $title');
      log('upgrader: showDialog message: $message');
      log('upgrader: showDialog releaseNotes: $releaseNotes');
    }

    // Save the date/time as the last time alerted.
    saveLastAlerted();

    /// set doc to firestore
    // saveToFirebase(
    //   version: version,
    //   title: title,
    //   message: message,
    //   releaseNotes: releaseNotes,
    // );

    showDialog(
      barrierDismissible: canDismissDialog,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => _shouldPopScope(),
          child: _DialogWidget(
            borderRadius: borderRadius,
            elevation: elevation,
            padding: padding,
            textColor: textColor,
            backgroundColor: backgroundColor,
            title: title ?? '',
            message: message,
            releaseNotes: releaseNotes,
            showIgnore: showIgnore,
            showLater: showLater,
            showReleaseNotes: showReleaseNotes,
            canDismissDialog: canDismissDialog,
            cupertino: dialogStyle == UpgradeDialogStyle.cupertino,
            messages: messages,
            onUserIgnored: onUserIgnored,
            onUserLater: onUserLater,
            onUserUpdated: onUserUpdated,
            blocked: blocked,
            shouldPopScope: shouldPopScope,
          ),
          // child: _alertDialog(
          //   title ?? '',
          //   message,
          //   releaseNotes,
          //   context,
          //   dialogStyle == UpgradeDialogStyle.cupertino,
          // )
        );
      },
    );
  }

  bool _shouldPopScope() {
    if (debugLogging) {
      log('upgrader: onWillPop called');
    }
    if (shouldPopScope != null) {
      final should = shouldPopScope!();
      if (debugLogging) {
        log('upgrader: shouldPopScope=$should');
      }
      return should;
    }

    return false;
  }

  Widget _alertDialog(String title, String message, String? releaseNotes,
      BuildContext context, bool cupertino) {
    // config
    double _borderRadius = borderRadius;
    double _padding = padding;
    Color _backgroundColor = backgroundColor;
    Color _textColor = textColor;

    Widget? notes;

    if (releaseNotes != null) {
      notes = Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(messages.message(UpgraderMessage.releaseNotes) ?? '',
                  style: TextStyle(color: _textColor)),
              Text(releaseNotes, style: TextStyle(color: _textColor)),
            ],
          ));
    }
    final textTitle = Text(title,
        key: const Key('upgrader.dialog.title'),
        style: TextStyle(color: _textColor));
    final content = Container(
        constraints: const BoxConstraints(maxHeight: 400),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(message, style: TextStyle(color: _textColor)),
            Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(messages.message(UpgraderMessage.prompt) ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            if (notes != null) notes,
          ],
        )));
    final actions = <Widget>[
      if (showIgnore)
        _button(cupertino, messages.message(UpgraderMessage.buttonTitleIgnore),
            context, () => onUserIgnored(context, true),
            textColor: _textColor),
      if (showLater)
        _button(cupertino, messages.message(UpgraderMessage.buttonTitleLater),
            context, () => onUserLater(context, true),
            textColor: _textColor),
      _button(cupertino, messages.message(UpgraderMessage.buttonTitleUpdate),
          context, () => onUserUpdated(context, !blocked()),
          textColor: _textColor),
    ];

    return cupertino
        ? CupertinoAlertDialog(
            title: textTitle, content: content, actions: actions)
        : AlertDialog(title: textTitle, content: content, actions: actions);
  }

  void onUserIgnored(BuildContext context, bool shouldPop) {
    if (debugLogging) {
      log('upgrader: button tapped: ignore');
    }

    // If this callback has been provided, call it.
    var doProcess = true;
    if (onIgnore != null) {
      doProcess = onIgnore!();
    }

    if (doProcess) {
      _saveIgnored();
    }

    if (shouldPop) {
      popNavigator(context);
    }
  }

  void onUserLater(BuildContext context, bool shouldPop) {
    if (debugLogging) {
      log('upgrader: button tapped: later');
    }

    // If this callback has been provided, call it.
    var doProcess = true;
    if (onLater != null) {
      doProcess = onLater!();
    }

    if (doProcess) {}

    if (shouldPop) {
      popNavigator(context);
    }
  }

  void onUserUpdated(BuildContext context, bool shouldPop) {
    if (debugLogging) {
      log('upgrader: button tapped: update now');
    }

    // If this callback has been provided, call it.
    var doProcess = true;
    if (onUpdate != null) {
      doProcess = onUpdate!();
    }

    if (doProcess) {
      _sendUserToAppStore();
    }

    if (shouldPop) {
      popNavigator(context);
    }
  }

  static Future<void> clearSavedSettings() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('userIgnoredVersion');
    await prefs.remove('lastTimeAlerted');
    await prefs.remove('lastVersionAlerted');

    return;
  }

  void popNavigator(BuildContext context) {
    Navigator.of(context).pop();
    _displayed = false;
  }

  Future<bool> _saveIgnored() async {
    var prefs = await SharedPreferences.getInstance();

    _userIgnoredVersion = _appStoreVersion;
    await prefs.setString('userIgnoredVersion', _userIgnoredVersion ?? '');
    return true;
  }

  Future<bool> saveLastAlerted() async {
    var prefs = await SharedPreferences.getInstance();
    _lastTimeAlerted = DateTime.now();
    await prefs.setString('lastTimeAlerted', _lastTimeAlerted.toString());

    _lastVersionAlerted = _appStoreVersion;
    await prefs.setString('lastVersionAlerted', _lastVersionAlerted ?? '');

    _hasAlerted = true;
    return true;
  }

  Future<bool> _getSavedPrefs() async {
    var prefs = await SharedPreferences.getInstance();
    final lastTimeAlerted = prefs.getString('lastTimeAlerted');
    if (lastTimeAlerted != null) {
      _lastTimeAlerted = DateTime.parse(lastTimeAlerted);
    }

    _lastVersionAlerted = prefs.getString('lastVersionAlerted');

    _userIgnoredVersion = prefs.getString('userIgnoredVersion');

    return true;
  }

  void _sendUserToAppStore() async {
    if (_appStoreListingURL == null || _appStoreListingURL!.isEmpty) {
      if (debugLogging) {
        log('upgrader: empty _appStoreListingURL');
      }
      return;
    }

    if (debugLogging) {
      log('upgrader: launching: $_appStoreListingURL');
    }

    if (await canLaunchUrl(Uri.parse(_appStoreListingURL!))) {
      try {
        await launchUrl(Uri.parse(_appStoreListingURL!),
            mode: upgraderOS.isAndroid
                ? LaunchMode.externalNonBrowserApplication
                : LaunchMode.platformDefault);
      } catch (e) {
        if (debugLogging) {
          log('upgrader: launch to app store failed: $e');
        }
      }
    } else {}
  }

  // void saveToFirebase({
  //   required Version version,
  //   required String? title,
  //   required String message,
  //   String? releaseNotes,
  // }) async {
  //   try {
  //     releaseNotes ??= '';
  //     releaseNotes =
  //         releaseNotes.replaceAll('🚀 Welcome to My Wealth Club! 🚀', '');
  //     releaseNotes = releaseNotes.replaceAll(
  //         'Thank you for choosing My Wealth Club! Your success is our priority.',
  //         '');
  //     releaseNotes = releaseNotes.replaceAll(
  //         '© 2023 My Wealth Club. All Rights Reserved.', '');
  //     var whatsNew = WhatsNewModel(
  //       id: version.toString(),
  //       version: version,
  //       title: title ?? '',
  //       description: releaseNotes,
  //     );
  //     sl.get<FirebaseDatabase>().setWhatsNew(whatsNew);
  //   } catch (e) {
  //     errorLog('upgrader: saveToFirebase: $e');
  //   }
  // }
}

class _DialogWidget extends StatelessWidget {
  _DialogWidget({
    super.key,
    required this.borderRadius,
    required this.elevation,
    required this.padding,
    required this.textColor,
    required this.backgroundColor,
    required this.title,
    required this.message,
    required this.releaseNotes,
    required this.showIgnore,
    required this.showLater,
    required this.showReleaseNotes,
    required this.canDismissDialog,
    required this.cupertino,
    required this.messages,
    required this.onUserIgnored,
    required this.onUserLater,
    required this.onUserUpdated,
    required this.blocked,
    this.shouldPopScope,
  });
  double borderRadius;
  double elevation;
  double padding;
  Color textColor;
  Color backgroundColor;
  String title;
  String message;
  String? releaseNotes;
  bool showIgnore;
  bool showLater;
  bool showReleaseNotes;
  bool canDismissDialog;
  bool cupertino;
  UpgraderMessages messages;
  Function(BuildContext context, bool val) onUserIgnored;
  Function(BuildContext context, bool val) onUserLater;
  Function(BuildContext context, bool val) onUserUpdated;
  bool Function() blocked;
  bool Function()? shouldPopScope;

  @override
  Widget build(BuildContext context) {
    // config
    double _borderRadius = borderRadius;
    double _padding = padding;
    Color _backgroundColor = backgroundColor;
    Color _textColor = textColor;

    Widget? notes;

    if (releaseNotes != null) {
      notes = Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(messages.message(UpgraderMessage.releaseNotes) ?? '',
                  style: TextStyle(
                      color: _textColor, fontWeight: FontWeight.bold)),
              Text(releaseNotes!,
                  style: TextStyle(color: _textColor.withOpacity(0.9))),
            ],
          ));
    }
    final textTitle = Text(title,
        key: const Key('upgrader.dialog.title'),
        style: TextStyle(color: _textColor));
    final content = Container(
        constraints: const BoxConstraints(maxHeight: 400),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(message, style: TextStyle(color: _textColor.withOpacity(0.8))),
            Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(messages.message(UpgraderMessage.prompt) ?? '',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: _textColor))),
            if (notes != null) notes,
          ],
        )));
    final actions = <Widget>[
      if (showIgnore)
        _button(cupertino, messages.message(UpgraderMessage.buttonTitleIgnore),
            context, () => onUserIgnored(context, true),
            textColor: _textColor),
      if (showLater)
        _button(cupertino, messages.message(UpgraderMessage.buttonTitleLater),
            context, () => onUserLater(context, true),
            textColor: _textColor),
      _button(cupertino, messages.message(UpgraderMessage.buttonTitleUpdate),
          context, () => onUserUpdated(context, !blocked()),
          textColor: _textColor),
    ];
/*
    return Material(
        type: MaterialType.transparency,
        child: Container(
          child: SizedBox(
            width: dialogWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: dialogWidth,
                  child: widget.topImage ??
                      Image.asset('assets/update_bg_app_top.png',
                          package: 'flutter_update_dialog', fit: BoxFit.fill),
                ),
                Container(
                  width: dialogWidth,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 8),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(widget.radius),
                          bottomRight: Radius.circular(widget.radius)),
                    ),
                  ),
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: widget.extraHeight),
                        child: Text(widget.title,
                            style: TextStyle(
                                fontSize: widget.titleTextSize,
                                color: Colors.black)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(widget.updateContent,
                            style: TextStyle(
                                fontSize: widget.contentTextSize,
                                color: const Color(0xFF666666))),
                      ),
                      if (widget.progress < 0)
                        Column(children: <Widget>[
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                textStyle: MaterialStateProperty.all(
                                    TextStyle(fontSize: widget.buttonTextSize)),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor: MaterialStateProperty.all(
                                    widget.themeColor),
                              ),
                              child: Text(widget.updateButtonText),
                              onPressed: widget.onUpdate,
                            ),
                          ),
                          if (widget.enableIgnore && widget.onIgnore != null)
                            FractionallySizedBox(
                                widthFactor: 1,
                                child: TextButton(
                                  style: ButtonStyle(
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    textStyle: MaterialStateProperty.all(
                                        TextStyle(
                                            fontSize: widget.buttonTextSize)),
                                    foregroundColor: MaterialStateProperty.all(
                                        const Color(0xFF666666)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                  ),
                                  child: Text(widget.ignoreButtonText),
                                  onPressed: widget.onIgnore,
                                ))
                          else
                            const SizedBox()
                        ])
                      else
                        NumberProgress(
                            value: widget.progress,
                            backgroundColor: widget.progressBackgroundColor,
                            valueColor: widget.themeColor,
                            padding: const EdgeInsets.symmetric(vertical: 10))
                    ],
                  )),
                ),
              ],
            ),
          ),
        ));
*/
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Container(
          child: cupertino
              ? CupertinoAlertDialog(
                  title: textTitle,
                  content: content,
                  actions: actions,
                )
              : AlertDialog(
                  title: textTitle,
                  content: content,
                  actions: actions,
                  backgroundColor: _backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(_borderRadius)),
                  ),
                ),
        ),
        // Positioned(
        //   top: -10,
        //   right: 0,
        //   left: 0,
        //   child: Container(
        //     padding: EdgeInsets.all(10),
        //     child: RotatedBox(
        //       quarterTurns: 0,
        //       child: assetLottie(
        //         MyLottie.rocket,
        //         // width: 100,
        //         height: 200,
        //       ),
        //     ),
        //   ),
        // ),
        // Container(
        //   child: cupertino
        //       ? CupertinoAlertDialog(
        //           title: textTitle,
        //           content: content,
        //           actions: actions,
        //         )
        //       : AlertDialog(
        //           title: textTitle,
        //           content: content,
        //           actions: actions,
        //           backgroundColor: _backgroundColor,
        //           shape: RoundedRectangleBorder(
        //             borderRadius:
        //                 BorderRadius.all(Radius.circular(_borderRadius)),
        //           ),
        //         ),
        // ),
      ],
    );
  }

  // Widget getWidget() {
  //   final double dialogWidth =
  //       widget.width <= 0 ? getFitWidth(context) * 0.618 : widget.width;
  // }

  // double getFitWidth(BuildContext context) {
  //   return min(getScreenHeight(context), getScreenWidth(context));
  // }

  // double getScreenHeight(BuildContext context) {
  //   return MediaQuery.of(context).size.height;
  // }

  // double getScreenWidth(BuildContext context) {
  //   return MediaQuery.of(context).size.width;
  // }
}

Widget _button(
    bool cupertino, String? text, BuildContext context, VoidCallback? onPressed,
    {required Color textColor, TextStyle? cupertinoButtonTextStyle}) {
  return cupertino
      ? CupertinoDialogAction(
          textStyle: cupertinoButtonTextStyle,
          onPressed: onPressed,
          child: Text(text ?? '', style: TextStyle(color: textColor)))
      : TextButton(
          onPressed: onPressed,
          child: Text(text ?? '', style: TextStyle(color: textColor)));
}
