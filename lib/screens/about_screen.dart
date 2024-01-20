import 'package:coinxfiat/constants/constants_index.dart';
import 'package:coinxfiat/utils/picture_utils.dart';
import 'package:coinxfiat/utils/size_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../database/database_index.dart';
import '../store/store_index.dart';
import '/main.dart';
import '/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white, statusBarBrightness: Brightness.light));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language.about),
        centerTitle: true,
        elevation: 0,
      ),
      body: AnimatedScrollView(
        crossAxisAlignment: CrossAxisAlignment.center,
        listAnimationType: ListAnimationType.FadeIn,
        padding: const EdgeInsetsDirectional.all(DEFAULT_PADDING),
        fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
        children: [
          (DEFAULT_PADDING * 3).toInt().height,
          assetImages(
            getTheme(context).brightness == Brightness.light
                ? MyPng.logoLBlack
                : MyPng.logoLWhite,
          ),
          16.height,
          Text(AppConst.appName, style: boldTextStyle(size: 16)),
          8.height,
          Text(AppConst.appDescription,
              style: secondaryTextStyle(), maxLines: 2),
          8.height,
          Text('Version: 1.0.0', style: primaryTextStyle()),

          30.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // if (appStore.helplineNumber.isNotEmpty)
              Container(
                height: 80,
                width: 80,
                padding: const EdgeInsets.all(16),
                decoration: boxDecorationWithRoundedCorners(
                    borderRadius: radius(),
                    backgroundColor: context.scaffoldBackgroundColor),
                child: Column(
                  children: [
                    FaIcon(FontAwesomeIcons.phone,
                        size: DEFAULT_PADDING, color: primaryColor),
                    4.height,
                    Text(language.lblCall,
                        style: secondaryTextStyle(),
                        textAlign: TextAlign.center),
                  ],
                ),
              ).onTap(
                () {
                  log(appStore.helplineNumber);
                  toast(appStore.helplineNumber);
                  launchCall(appStore.helplineNumber);
                },
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              // if (appStore.inquiryEmail.isNotEmpty)
              Container(
                height: 80,
                width: 80,
                padding: const EdgeInsets.all(16),
                decoration: boxDecorationWithRoundedCorners(
                    borderRadius: radius(),
                    backgroundColor: context.scaffoldBackgroundColor),
                child: Column(
                  children: [
                    FaIcon(FontAwesomeIcons.envelope,
                        size: DEFAULT_PADDING, color: primaryColor),
                    4.height,
                    Text(language.email,
                        style: secondaryTextStyle(),
                        textAlign: TextAlign.center),
                  ],
                ),
              ).onTap(
                () {
                  launchMail(appStore.inquiryEmail);
                },
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
            ],
          ),
          if (getStringAsync(SITE_DESCRIPTION).isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(getStringAsync(SITE_DESCRIPTION),
                  style: primaryTextStyle(), textAlign: TextAlign.justify),
            ).paddingOnly(top: 25),
          30.height,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // if (getStringAsync(FACEBOOK_URL).isNotEmpty)
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.facebookF, size: 35),
                  onPressed: () {
                    commonLaunchUrl(getStringAsync(FACEBOOK_URL),
                        launchMode: LaunchMode.externalApplication);
                  },
                ).expand(),
                // if (getStringAsync(INSTAGRAM_URL).isNotEmpty)
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.instagram, size: 35),
                  onPressed: () {
                    commonLaunchUrl(getStringAsync(INSTAGRAM_URL),
                        launchMode: LaunchMode.externalApplication);
                  },
                ).expand(),
                // if (getStringAsync(TWITTER_URL).isNotEmpty)
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.twitter, size: 35),
                  onPressed: () {
                    commonLaunchUrl(getStringAsync(TWITTER_URL),
                        launchMode: LaunchMode.externalApplication);
                  },
                ).expand(),
                // if (getStringAsync(LINKEDIN_URL).isNotEmpty)
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.linkedinIn, size: 35),
                  onPressed: () {
                    commonLaunchUrl(getStringAsync(LINKEDIN_URL),
                        launchMode: LaunchMode.externalApplication);
                  },
                ).expand(),
                // if (getStringAsync(YOUTUBE_URL).isNotEmpty)
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.youtube, size: 35),
                  onPressed: () {
                    commonLaunchUrl(getStringAsync(YOUTUBE_URL),
                        launchMode: LaunchMode.externalApplication);
                  },
                ).expand(),
              ],
            ),
          ),
          25.height,

          ///version
        ],
      ),
    );
  }
}
