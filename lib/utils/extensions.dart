import 'package:coinxfiat/constants/constants_index.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../store/store_index.dart';
import 'package:flutter/material.dart';

extension strEtx on String {
  Widget iconImage({double? size, Color? color, BoxFit? fit}) {
    return Image.asset(
      this,
      height: size ?? 24,
      width: size ?? 24,
      fit: fit ?? BoxFit.cover,
      color: color ??
          (appStore.isDarkMode ? Colors.white : AppConst.defaultPrimaryColor),
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(MyPng.icNoPhoto,
            height: size ?? 24, width: size ?? 24);
      },
    );
  }

  ///to double with dynamic decimal
  double convertDouble([int decimal = 2]) {
    return (double.tryParse(this) ?? 0.0).toStringAsFixed(decimal).toDouble();
  }

  ///get first letter
  String getFirstLetter([String suffix = '']) {
    if (isNotEmpty) {
      return trim().substring(0, 1) + suffix;
    }
    return '';
  }

  ///get last letter
  String getLastLetter([String preffix = '']) {
    if (isNotEmpty) {
      return preffix + trim().substring(length - 1, length);
    }
    return '';
  }
}

extension numExt on num? {
  // to double with dynamic decimal
  double convertDouble([int decimal = 2]) {
    String value = (this ?? 0).toStringAsFixed(decimal);
    return value.convertDouble(decimal);
  }
}

extension listExt<E> on Iterable<E> {
  /// firstWhereOrNull
  E? firstWhereOrNull(bool Function(E) test, {E Function()? orElse}) {
    try {
      return firstWhere(test);
    } catch (e) {
      return orElse?.call();
    }
  }
}

extension skeleton on Widget {
  Widget skeletonize({
    required bool enabled,
    double borderRadius = 3.0,
    Color? baseColor,
    Color? highlightColor,
    bool ignoreContainers = false,
    bool ignorePointers = false,
    bool justifyMultiLineText = false,
  }) {
    return Skeletonizer(
      enabled: enabled,
      containersColor: baseColor ?? Colors.grey[300]!,
      ignoreContainers: ignoreContainers,
      ignorePointers: ignorePointers,
      justifyMultiLineText: justifyMultiLineText,
      textBoneBorderRadius:
          TextBoneBorderRadius(BorderRadius.circular(borderRadius)),
      child: this,
    );
  }
}
