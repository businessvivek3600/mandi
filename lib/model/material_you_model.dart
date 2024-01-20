import '../constants/constants_index.dart';
import '../store/store_index.dart';
import '/main.dart';
import '/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

Future<Color> getMaterialYouData() async {
  if (appStore.useMaterialYouTheme && await isAndroid12Above()) {
    primaryColor = await getMaterialYouPrimaryColor();
  } else {
    primaryColor = AppConst.defaultPrimaryColor;
  }

  return primaryColor;
}
