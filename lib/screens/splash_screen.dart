import 'package:coinxfiat/constants/constants_index.dart';
import 'package:coinxfiat/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import '../routes/route_index.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    afterBuildCreated(() =>
        1.seconds.delay.then((value) => context.goNamed(Routes.dashboard)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: getTheme(context).secondaryHeaderColor,
      body: assetImages(MyPng.logo, fit: BoxFit.cover)
          .center()
          .paddingSymmetric(
              vertical: getHeight(context) * 0.2,
              horizontal: getWidth(context) * 0.2),
    );
  }
}
