import 'package:coinxfiat/constants/constants_index.dart';
import 'package:coinxfiat/routes/route_index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import '../store/store_index.dart';
import '../utils/utils_index.dart';
import 'widget_index.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget(
      {required this.child,
      super.key,
      required this.context,
      required this.goRouter});
  final BuildContext context;
  final Widget child;
  final GoRouter goRouter;

  // static Future<void> showLoadingDialog<T>({
  //   String? loadingMessage,
  // }) async {
  //   // flutter defined function
  //   return showDialog(
  //     context: context,
  //     // barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return WillPopScope(
  //         onWillPop: () async => false,
  //         child: SimpleDialog(
  //           backgroundColor: Colors.black54,
  //           children: <Widget>[
  //             Center(
  //               child: Column(children: [
  //                 CircularProgressIndicator(),
  //                 SizedBox(height: 10),
  //                 Text(loadingMessage ?? 'Please wait...',
  //                     style: TextStyle(color: Colors.blueAccent))
  //               ]),
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) => Material(
        child: Stack(
          children: [
            child,
            Observer(
              builder: (_) => Visibility(
                  visible: appStore.isLoading,
                  child: AnimatedContainer(
                      duration: 500.milliseconds,
                      color: Colors.black.withOpacity(0.1),
                      child: Center(
                          child: SpinKitChasingDots(color: primaryColor)))),
            ),
            Observer(
              builder: (_) => Visibility(
                  visible: appStore.isSessionExpired,
                  child: AlertDialog(
                    title:  Text('Session Expired',style: boldTextStyle(size: 23)),
                    content: Row(
                      children: [
                        const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator.adaptive())
                            .paddingRight(DEFAULT_PADDING),
                        RichText(
                          text: TextSpan(
                            text: 'Your session has expired. Please ',
                            style: boldTextStyle(),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'login',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      appStore.setSessionExpired(false);
                                      goRouter.go(Paths.login);
                                    },
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const TextSpan(text: ' to continue.'),
                            ],
                          ),
                        ).expand(),
                      ],
                    ),
                  )),
            ),
          ],
        ).onTap(() {
          if (defaultTargetPlatform == TargetPlatform.android) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
              // SystemUiOverlay.bottom,
              SystemUiOverlay.top,
            ]);
            SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent, // Status bar color
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarContrastEnforced: true,
            ));
          }
        }),
      );
}
