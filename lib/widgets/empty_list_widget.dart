import 'package:coinxfiat/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constants/constants_index.dart';

/// Empty List Widget
class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({
    Key? key,
    this.message,
    this.refresh,
    this.height = 100,
    this.width = 100,
    this.lottie,
  }) : super(key: key);
  final String? lottie;
  final String? message;
  final Function? refresh;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          assetLottie(lottie ?? MyLottie.emptyBox,
              height: height, width: width),
          16.height,
          Text(
            message ?? 'No data found',
            style: secondaryTextStyle(size: 16),
            textAlign: TextAlign.center,
          ),
          16.height,
          if (refresh != null)
            TextButton.icon(
              onPressed: () => refresh?.call(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            )
        ],
      ),
    );
  }
}
