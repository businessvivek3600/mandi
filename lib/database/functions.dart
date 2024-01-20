import 'dart:io';

import 'package:coinxfiat/screens/auth/auth_screen.dart';
import 'package:coinxfiat/utils/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import '../constants/constants_index.dart';
import '../main.dart';
import '../store/store_index.dart';
import '../utils/utils_index.dart';
import 'app_update/upgrader.dart';

exitTheApp() async {
  if (Platform.isAndroid) {
    SystemNavigator.pop();
  } else if (Platform.isIOS) {
    exit(0);
  } else {
    print('App exit failed!');
  }
}

int fnv1a(String input) {
  final fnvOffset = BigInt.parse('14695981039346656037');
  const fnvPrime = 1099511628211;

  int hash = fnvOffset.toInt();
  for (int i = 0; i < input.length; i++) {
    hash ^= input.codeUnitAt(i);
    hash *= fnvPrime;
  }
  return hash;
}

String generateColorCode(String text) {
  int hash = fnv1a(text);
  return '#' + (hash & 0xFFFFFF).toRadixString(16).padLeft(6, '0');
}

// Future<CroppedFile?> cropImage(String path) async {
//   var context = Get.context!;
//   final croppedFile = await ImageCropper().cropImage(
//     sourcePath: path,
//     compressFormat: ImageCompressFormat.jpg,
//     compressQuality: 100,
//     uiSettings: [
//       AndroidUiSettings(
//           toolbarTitle: 'Resize your image',
//           toolbarColor: getTheme(context).appLogoColor,
//           toolbarWidgetColor: Colors.white,
//           initAspectRatio: CropAspectRatioPreset.original,
//           lockAspectRatio: false),
//       IOSUiSettings(
//         title: 'Resize your image',
//         showActivitySheetOnDone: false,
//         showCancelConfirmationDialog: true,
//         cancelButtonTitle: 'Cancel',
//         doneButtonTitle: 'Update Profile',
//         hidesNavigationBar: true,
//         resetAspectRatioEnabled: true,
//         aspectRatioPickerButtonHidden: true,
//         aspectRatioLockEnabled: true,
//         aspectRatioLockDimensionSwapEnabled: true,
//       ),
//       WebUiSettings(
//         context: context,
//         presentStyle: CropperPresentStyle.dialog,
//         boundary: const CroppieBoundary(
//           width: 520,
//           height: 520,
//         ),
//         viewPort:
//             const CroppieViewPort(width: 480, height: 480, type: 'circle'),
//         enableExif: true,
//         enableZoom: true,
//         showZoomer: true,
//       ),
//     ],
//   );
//   return croppedFile;
// }

///save image to local
Future<String> downloadAndSaveFile(String url, String fileName) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final http.Response respose = await http.get(Uri.parse(url));
  final File file = File(filePath);
  await file.writeAsBytes(respose.bodyBytes);
  return filePath;
}

///xml
Future<Map<String, String>> loadStringXml(String path) async {
  String xmlString = await rootBundle.loadString(path);
  Map<String, String> stringMap = parseStringXml(xmlString);
  return stringMap;
}

Map<String, String> parseStringXml(String xmlString) {
  var document = xml.XmlDocument.parse(xmlString);
  var stringNodes = document.findAllElements('string').toList();

  Map<String, String> stringMap = {};
  logger.i('parseStringXml stringNodes: $stringNodes');
  for (var node in stringNodes) {
    var name = node.getAttribute('name');
    var value = node.innerText;
    if (name != null) {
      stringMap[name] = value.validate();
    }
  }

  return stringMap;
}

// working update
checkForUpdate(BuildContext context) async {
  Upgrader upgrader = Upgrader(
    debugLogging: true,
    showIgnore: false,
    showLater: false,
    debugDisplayAlways: false,
    durationUntilAlertAgain: const Duration(seconds: 1),
    shouldPopScope: () => true,
    dialogStyle: Platform.isIOS
        ? UpgradeDialogStyle.cupertino
        : UpgradeDialogStyle.material,
    willDisplayUpgrade: (
        {String? appStoreVersion,
        required bool display,
        String? installedVersion,
        String? minAppVersion}) async {
      logger.i(
          'appStoreVersion: $appStoreVersion display: $display '
          'installedVersion: $installedVersion minAppVersion: $minAppVersion',
          tag: 'checkForUpdate');
    },
    backgroundColor: Platform.isIOS ? Colors.white : Colors.black,
    borderRadius: 10,
    textColor: Platform.isIOS ? Colors.black : Colors.white,
  );
  try {
    await upgrader
        .initialize()
        .then((value) => upgrader.checkVersion(context: context));
  } catch (e) {
    logger.e('upgrader.initialize()',
        error: e, stackTrace: StackTrace.current, tag: 'checkForUpdate');
  }
}

Future<void> commonLaunchUrl(String address,
    {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    toast('${language.invalidURL}: $address');
  });
}

void launchCall(String? url) {
  if (url.validate().isNotEmpty) {
    if (isIOS) {
      commonLaunchUrl('tel://${url!}',
          launchMode: LaunchMode.externalApplication);
    } else {
      commonLaunchUrl('tel:${url!}',
          launchMode: LaunchMode.externalApplication);
    }
  }
}

void launchMap(String? url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl(GOOGLE_MAP_PREFIX + url!,
        launchMode: LaunchMode.externalApplication);
  }
}

void launchMail(String url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl('$MAIL_TO$url', launchMode: LaunchMode.externalApplication);
  }
}

void checkIfLink(BuildContext context, String value, {String? title}) {
  if (value.validate().isEmpty) return;

  String temp = parseHtmlString(value.validate());
  if (temp.startsWith("https") || temp.startsWith("http")) {
    launchUrlCustomTab(temp.validate());
  } else if (temp.validateEmail()) {
    launchMail(temp);
  } else if (temp.validatePhone() || temp.startsWith('+')) {
    launchCall(temp);
  } else {
    // HtmlWidget(postContent: value, title: title).launch(context);
  }
}

void launchUrlCustomTab(String? url) {
  if (url.validate().isNotEmpty) {
    custom_tabs.launch(
      url!,
      customTabsOption: const custom_tabs.CustomTabsOption(
        enableDefaultShare: true,
        enableInstantApps: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        // toolbarColor: appLogoColor,
      ),
      safariVCOption: const custom_tabs.SafariViewControllerOption(
        // preferredBarTintColor: appLogoColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  }
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(
        id: 1,
        name: 'English',
        languageCode: 'en',
        fullLanguageCode: 'en-US',
        flag: 'assets/flag/ic_us.png'),
    LanguageDataModel(
        id: 2,
        name: 'Hindi',
        languageCode: 'hi',
        fullLanguageCode: 'hi-IN',
        flag: 'assets/flag/ic_india.png'),
    LanguageDataModel(
        id: 3,
        name: 'Arabic',
        languageCode: 'ar',
        fullLanguageCode: 'ar-AR',
        flag: 'assets/flag/ic_ar.png'),
    LanguageDataModel(
        id: 4,
        name: 'French',
        languageCode: 'fr',
        fullLanguageCode: 'fr-FR',
        flag: 'assets/flag/ic_fr.png'),
    LanguageDataModel(
        id: 5,
        name: 'German',
        languageCode: 'de',
        fullLanguageCode: 'de-DE',
        flag: 'assets/flag/ic_de.png'),
  ];
}

InputDecoration inputDecoration(BuildContext context,
    {Widget? prefixIcon, String? labelText, double? borderRadius}) {
  return InputDecoration(
    contentPadding:
        const EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    labelStyle: secondaryTextStyle(),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? DEFAULT_RADIUS),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? DEFAULT_RADIUS),
      borderSide: const BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? DEFAULT_RADIUS),
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    border: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? DEFAULT_RADIUS),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? DEFAULT_RADIUS),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? DEFAULT_RADIUS),
      // borderSide: BorderSide(color: appLogoColor, width: 0.0),
    ),
    filled: true,
    fillColor: context.cardColor,
  );
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

String formatDate(String? dateTime,
    {String format = DATE_FORMAT_1,
    bool isFromMicrosecondsSinceEpoch = false,
    bool isLanguageNeeded = true}) {
  final languageCode = isLanguageNeeded ? appStore.selectedLanguageCode : null;
  final parsedDateTime = isFromMicrosecondsSinceEpoch
      ? DateTime.fromMicrosecondsSinceEpoch(dateTime.validate().toInt() * 1000)
      : DateTime.parse(dateTime.validate());

  return DateFormat(format, languageCode).format(parsedDateTime);
}

///Todo: check if this is needed

// void locationWiseService(BuildContext context, VoidCallback onTap) async {
//   Permissions.cameraFilesAndLocationPermissionsGranted().then((value) async {
//     await setValue(PERMISSION_STATUS, value);

//     if (value) {
//       bool? res = await showInDialog(
//         context,
//         contentPadding: EdgeInsets.zero,
//         builder: (p0) {
//           return AppCommonDialog(
//             title: language.lblAlert,
//             child: LocationServiceDialog(),
//           );
//         },
//       );

//       if (res ?? false) {
//         appStore.setLoading(true);

//         await setValue(PERMISSION_STATUS, value);
//         await getUserLocation().then((value) async {
//           await appStore.setCurrentLocation(!appStore.isCurrentLocation);
//         }).catchError((e) {
//           appStore.setLoading(false);
//           toast(e.toString(), print: true);
//         });

//         onTap.call();
//       }
//     }
//   }).catchError((e) {
//     toast(e.toString(), print: true);
//   });
// }

// Logic For Calculate Time
String calculateTimer(int secTime) {
  int hour = 0, minute = 0, seconds = 0;

  hour = secTime ~/ 3600;

  minute = ((secTime - hour * 3600)) ~/ 60;

  seconds = secTime - (hour * 3600) - (minute * 60);

  String hourLeft = hour.toString().length < 2 ? "0$hour" : hour.toString();

  String minuteLeft =
      minute.toString().length < 2 ? "0$minute" : minute.toString();

  String minutes = minuteLeft == '00' ? '01' : minuteLeft;

  String result = "$hourLeft:$minutes";

  log(seconds);

  return result;
}

String getPaymentStatusText(String? status, String? method) {
  // if (status!.isEmpty) {
  //   return language.lblPending;
  // } else if (status == SERVICE_PAYMENT_STATUS_PAID ||
  //     status == PENDING_BY_ADMIN) {
  //   return language.paid;
  // } else if (status == SERVICE_PAYMENT_STATUS_ADVANCE_PAID) {
  //   return language.advancePaid;
  // } else if (status == SERVICE_PAYMENT_STATUS_PENDING &&
  //     method == PAYMENT_METHOD_COD) {
  //   return language.pendingApproval;
  // } else if (status == SERVICE_PAYMENT_STATUS_PENDING) {
  //   return language.lblPending;
  // } else {
  //   return "";
  // }

  return "";
}

String buildPaymentStatusWithMethod(String status, String method) {
  // return '${getPaymentStatusText(status, method)}${(status == SERVICE_PAYMENT_STATUS_PAID || status == PENDING_BY_ADMIN) ? ' ${language.by} ${method.capitalizeFirstLetter()}' : ''}';
  return "";
}

///TODO: check if this is needed
// Color getRatingBarColor(int rating, {bool showRedForZeroRating = false}) {
//   if (rating == 1 || rating == 2) {
//     return showRedForZeroRating ? showRedForZeroRatingColor : ratingBarColor;
//   } else if (rating == 3) {
//     return const Color(0xFFff6200);
//   } else if (rating == 4 || rating == 5) {
//     return const Color(0xFF73CB92);
//   } else {
//     return showRedForZeroRating ? showRedForZeroRatingColor : ratingBarColor;
//   }
// }

///TODO: check if this is needed
// Future<FirebaseRemoteConfig> setupFirebaseRemoteConfig() async {
//   final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

//   try {
//     remoteConfig.setConfigSettings(RemoteConfigSettings(
//         fetchTimeout: Duration.zero, minimumFetchInterval: Duration.zero));
//     await remoteConfig.fetch();
//     await remoteConfig.fetchAndActivate();
//   } catch (e) {
//     throw language.firebaseRemoteCannotBe;
//   }
//   if (remoteConfig.getString(USER_CHANGE_LOG).isNotEmpty) {
//     await compareValuesInSharedPreference(
//         USER_CHANGE_LOG, remoteConfig.getString(USER_CHANGE_LOG));
//   }
//   if (remoteConfig.getString(USER_CHANGE_LOG).validate().isNotEmpty) {
//     remoteConfigDataModel = RemoteConfigDataModel.fromJson(
//         jsonDecode(remoteConfig.getString(USER_CHANGE_LOG)));

//     await compareValuesInSharedPreference(
//         IN_MAINTENANCE_MODE, remoteConfigDataModel.inMaintenanceMode);

//     if (isIOS) {
//       await compareValuesInSharedPreference(
//           HAS_IN_REVIEW, remoteConfig.getBool(HAS_IN_APP_STORE_REVIEW));
//     } else if (isAndroid) {
//       await compareValuesInSharedPreference(
//           HAS_IN_REVIEW, remoteConfig.getBool(HAS_IN_PLAY_STORE_REVIEW));
//     }
//   }

//   return remoteConfig;
// }

void ifNotTester(VoidCallback callback) {
  if (appStore.userEmail != AppConst.testerEmail) {
    callback.call();
  } else {
    toast(language.lblUnAuthorized);
  }
}

void doIfLoggedIn(BuildContext context, VoidCallback callback) {
  if (appStore.isLoggedIn) {
    callback.call();
  } else {
    const AuthScreen(returnExpected: true, returnPath: '')
        .launch(context)
        .then((value) {
      if (value ?? false) {
        callback.call();
      }
    });
  }
}

Widget get trailing {
  return MyPng.icArrowRight.iconImage(size: 16);
}

bool isTodayAfterDate(DateTime val) => val.isAfter(todayDate);

Widget mobileNumberInfoWidget() {
  return RichTextWidget(
    list: [
      TextSpan(text: language.addYourCountryCode, style: secondaryTextStyle()),
      TextSpan(text: ' "91-", "236-" ', style: boldTextStyle(size: 12)),
      TextSpan(
        text: ' (${language.help})',
        // style: boldTextStyle(size: 12, color: appLogoColor),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            launchUrlCustomTab("https://countrycode.org/");
          },
      ),
    ],
  );
}

Future<bool> compareValuesInSharedPreference(String key, dynamic value) async {
  bool status = false;
  if (value is String) {
    status = getStringAsync(key) == value;
  } else if (value is bool) {
    status = getBoolAsync(key) == value;
  } else if (value is int) {
    status = getIntAsync(key) == value;
  } else if (value is double) {
    status = getDoubleAsync(key) == value;
  }

  if (!status) {
    await setValue(key, value);
  }
  return status;
}

// Future<File> getCameraImage({bool isCamera = true}) async {
//   final pickedImage = await ImagePicker()
//       .pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
//   return File(pickedImage!.path);
// }

// Future<List<File>> getMultipleImageSource({bool isCamera = true}) async {
//   final pickedImage = await ImagePicker().pickMultiImage();
//   return pickedImage.map((e) => File(e.path)).toList();
// }

////constants
DateTime todayDate = DateTime.now();

//region DateFormat
const DATE_FORMAT_1 = 'dd-MMM-yyyy hh:mm a';
const DATE_FORMAT_2 = 'd MMM, yyyy';
const DATE_FORMAT_3 = 'dd-MMM-yyyy';
const HOUR_12_FORMAT = 'hh:mm a';
const DATE_FORMAT_4 = 'dd MMM';
const DATE_FORMAT_7 = 'yyyy-MM-dd';
const DATE_FORMAT_8 = 'd MMM, yyyy hh:mm a';
const YEAR = 'yyyy';
const BOOKING_SAVE_FORMAT = "yyyy-MM-dd kk:mm:ss";
//endregion

//region Mail And Tel URL
const MAIL_TO = 'mailto:';
const TEL = 'tel:';
const GOOGLE_MAP_PREFIX = 'https://www.google.com/maps/search/?api=1&query=';

SlideConfiguration sliderConfigurationGlobal =
    SlideConfiguration(duration: 400.milliseconds, delay: 50.milliseconds);
