import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../store/store_index.dart';
import '../utils/utils_index.dart';
import 'widget_index.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({required this.child, super.key, required this.context});
  final BuildContext context;
  final Widget child;

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
