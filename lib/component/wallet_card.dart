import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../constants/constants_index.dart';
import '../utils/utils_index.dart';

class WalletCard extends StatelessWidget {
  const WalletCard(
      {super.key,
      required this.title,
      this.subTitle,
      required this.amount,
      required this.image,
      this.loading = false,
      this.onTap});
  final String title;
  final String? subTitle;
  final dynamic amount;
  final String image;
  final VoidCallback? onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: loading,
      child: Container(
        constraints: const BoxConstraints(minWidth: 200),
        decoration: BoxDecoration(
          // color: context.dividerColor,
          borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
          border: loading
              ? null
              : Border.all(
                  color: context.primaryColor.withOpacity(0.3), width: 2),
          image: DecorationImage(
              image: assetImageProvider(MyPng.walletCardBg),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  context.accentColor.withOpacity(0.9), BlendMode.srcATop)),
        ),
        margin: const EdgeInsets.only(right: DEFAULT_PADDING),
        padding: const EdgeInsets.all(DEFAULT_PADDING / 2),
        child: Stack(
          children: [
            Container(),

            ///icon
            Positioned(
                bottom: DEFAULT_PADDING / 3,
                right: 0,
                height: DEFAULT_PADDING * 2,
                width: DEFAULT_PADDING * 2,
                child: netImages(image, placeholder: MyPng.coinDummy)),

            ///title
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        title,
                        style: boldTextStyle(color: Colors.white),
                        maxLines: 2,
                        minFontSize: 10,
                        maxFontSize: 20,
                        textAlign: TextAlign.center,
                      ),
                      width10(),
                      const FaIcon(FontAwesomeIcons.barsProgress,
                              color: Colors.white)
                          .onTap(() => onTap?.call()),
                    ],
                  ),
                ],
              ),
            ),

            ///amount
            Positioned(
              bottom: DEFAULT_PADDING / 2,
              left: 0,
              right: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bodyMedText(amount.toString(), context,
                      style: boldTextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ).onTap(() => onTap?.call()),
    );
  }
}
