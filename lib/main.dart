import 'package:coinxfiat/constants/constants_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import 'database/database_index.dart';
import 'locale/language_en.dart';
import 'locale/languages.dart';
import 'model/model_index.dart';
import 'routes/route_index.dart';
import 'services/service_index.dart';
import 'store/store_index.dart';
import 'utils/utils_index.dart';
import 'widgets/widget_index.dart';

//region Global Variables
BaseLanguage language = LanguageEn();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNbUtils().then((value) async => await initialize());
  await setupAppStore();
  await initializeUserData();
  setStatusBarColor(Colors.transparent,
      statusBarIconBrightness: Brightness.light);
  FlutterError.onError = (FlutterErrorDetails details) {
    logger.e('FlutterError.onError: $details',
        error: details, stackTrace: details.stack);
    saveErrorLog(details);
  };

  runApp(const MyApp());
}

Future<void> initNbUtils() async {
  passwordLengthGlobal = 6;
  appButtonBackgroundColorGlobal = Colors.blueGrey;
  defaultAppButtonTextColorGlobal = Colors.white;
  defaultBlurRadius = 0;
  defaultSpreadRadius = 0;
  textSecondaryColorGlobal = Colors.grey;
  textPrimaryColorGlobal = Colors.black;
  defaultAppButtonElevation = 0;
  pageRouteTransitionDurationGlobal = 400.milliseconds;
  textBoldSizeGlobal = 14;
  textPrimarySizeGlobal = 14;
  textSecondarySizeGlobal = 12;
  localeLanguageList = languageList();
}

///setup app store
Future<void> setupAppStore() async {
  ///check for login
  await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN), isInitializing: true);

  ///check for theme mode
  int themeModeIndex =
      getIntAsync(THEME_MODE_INDEX, defaultValue: THEME_MODE_SYSTEM);
  if (themeModeIndex == THEME_MODE_LIGHT) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == THEME_MODE_DARK) {
    appStore.setDarkMode(true);
  }
}

///initialize user data
Future<void> initializeUserData() async {
  //check for material you theme
  await appStore.setUseMaterialYouTheme(getBoolAsync(USE_MATERIAL_YOU_THEME),
      isInitializing: true);
  // await setValue(TOKEN, 'EgANjoDNEyOHu9pqadiAyGzaXCqeP5V5a3YKIgVr');
  var token = getStringAsync(TOKEN);
  dioClient = DioClient(AppConst.baseUrl, null,
      loggingInterceptor: LoggingInterceptor());

  ///initialize user data
  if (appStore.isLoggedIn && token.isNotEmpty) {
    await appStore.setUserId(getIntAsync(USER_ID), isInitializing: true);
    await appStore.setFirstName(getStringAsync(FIRST_NAME),
        isInitializing: true);
    await appStore.setLastName(getStringAsync(LAST_NAME), isInitializing: true);
    await appStore.setUserEmail(getStringAsync(USER_EMAIL),
        isInitializing: true);
    await appStore.setUserName(getStringAsync(USERNAME), isInitializing: true);
    await appStore.setContactNumber(getStringAsync(CONTACT_NUMBER),
        isInitializing: true);
    await appStore.setUserProfile(getStringAsync(PROFILE_IMAGE),
        isInitializing: true);
    await appStore.setCountryId(getIntAsync(COUNTRY_ID), isInitializing: true);
    await appStore.setStateId(getIntAsync(STATE_ID), isInitializing: true);
    await appStore.setCityId(getIntAsync(COUNTRY_ID), isInitializing: true);
    await appStore.setUId(getStringAsync(UID), isInitializing: true);
    await appStore.setAddress(getStringAsync(ADDRESS), isInitializing: true);
    await appStore.setCurrencyCode(getStringAsync(CURRENCY_COUNTRY_CODE),
        isInitializing: true);
    await appStore.setCurrencyCountryId(getStringAsync(CURRENCY_COUNTRY_ID),
        isInitializing: true);
    await appStore.setCurrencySymbol(getStringAsync(CURRENCY_COUNTRY_SYMBOL),
        isInitializing: true);
    await appStore.setPrivacyPolicy(getStringAsync(PRIVACY_POLICY),
        isInitializing: true);
    await appStore.setLoginType(getStringAsync(LOGIN_TYPE),
        isInitializing: true);
    await appStore.setPlayerId(getStringAsync(PLAYERID), isInitializing: true);
    await appStore.setTermConditions(getStringAsync(TERM_CONDITIONS),
        isInitializing: true);
    await appStore.setInquiryEmail(getStringAsync(INQUIRY_EMAIL),
        isInitializing: true);
    await appStore.setHelplineNumber(getStringAsync(HELPLINE_NUMBER),
        isInitializing: true);
    await appStore.setEnableUserWallet(getBoolAsync(ENABLE_USER_WALLET),
        isInitializing: true);
    await appStore.setToken(getStringAsync(TOKEN), isInitializing: true);
    dioClient.updateHeader(getStringAsync(TOKEN));
    AuthService().getUserByToken();
  }
}

///MyApp
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RestartAppWidget(
      child: Observer(
        builder: (_) => FutureBuilder<Color>(
          future: getMaterialYouData(),
          builder: (_, snap) {
            return Observer(
              builder: (_) => MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  routerConfig: goRouter,
                  // navigatorKey: navigatorKey,
                  // home: const SplashScreen(),
                  theme: AppTheme.dynamicTheme(lightThemeSetColor),
                  darkTheme: AppTheme.dynamicTheme(darkThemeSetColor),
                  themeMode:
                      appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  title: AppConst.appName,
                  // supportedLocales: LanguageDataModel.languageLocales(),
                  // localizationsDelegates: const [
                  //   AppLocalizations(),
                  //   GlobalMaterialLocalizations.delegate,
                  //   GlobalWidgetsLocalizations.delegate,
                  //   GlobalCupertinoLocalizations.delegate,
                  // ],
                  // localeResolutionCallback: (locale, supportedLocales) => locale,
                  // locale: Locale(appStore.selectedLanguageCode),
                  builder: (context, child) =>
                      LoadingWidget(context: context, child: child!)),
            );
          },
        ),
      ),
    );
  }
}
