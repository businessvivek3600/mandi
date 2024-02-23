import 'package:coinxfiat/database/functions.dart';
import 'package:coinxfiat/utils/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/constants_index.dart';
import '../../../model/model_index.dart';
import '../../../services/service_index.dart';
import '../../../store/store_index.dart';
import '../../../utils/utils_index.dart';

class DashboardFragment extends StatefulWidget {
  const DashboardFragment({super.key});

  @override
  State<DashboardFragment> createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment>
    with TickerProviderStateMixin {
  int currentIndex = 0;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    dashboardStore.getDashboardData();
    checkForUpdate(context);

    /// appStore
    afterBuildCreated(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        body: AnimatedScrollView(
          onSwipeRefresh: () async {
            await dashboardStore.getDashboardData();
          },
          padding: const EdgeInsets.only(
            left: DEFAULT_PADDING,
            right: DEFAULT_PADDING,
            bottom: DEFAULT_PADDING + kToolbarHeight,
          ),
          listAnimationType: ListAnimationType.FadeIn,
          children: [
            /// Container for varification mobile notice and verify action
            verifyMobileNumber(context)
                .paddingOnly(top: DEFAULT_PADDING / 2)
                .visible(!appStore.mobileVerified),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(MyDateUtils.formatDate(DateTime.now(), 'dd MMMM yyyy'),
                    style: boldTextStyle(
                        size: 16, decoration: TextDecoration.underline)),
              ],
            ).paddingTop(10),
            dashboardStore.isLoading ? buildLoadingGrid() : buildGrid(),

            ///Notice section
            buildNotice(context)
                .paddingOnly(top: DEFAULT_PADDING / 2)
                .visible(dashboardStore.notice.validate().isNotEmpty),
            (context.height() ~/ 2).height,
          ],
        ),

        // body: Stack(
        //   children: [
        //     Container(color: context.scaffoldBackgroundColor),

        //     /// This is the main content
        //     _Header(setDefaultHight: (double hight) {}),

        //     /// This is the trade counts card list in horizontal
        //     _RestBody(
        //       topPadding:
        //           _topPadding >= kToolbarHeight ? _topPadding : kToolbarHeight,
        //       scrollController: _scrollController,
        //       loading: dashboardStore.isLoading,
        //     ),
        //   ],
        // ),

        // bottomSheet: _RestBody(
        //   topPadding: 0,
        //   scrollController: _scrollController,
        //   loading: dashboardStore.isLoading,
        // ),
      ),
    );
  }

  Container verifyMobileNumber(BuildContext context) {
    return Container(
      width: context.width(),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.indigo),
        borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
      ),
      padding: const EdgeInsets.all(DEFAULT_PADDING / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 'Your mobile number is not verified. Click here to complete the verification process.',
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Your mobile number is not verified. ',
                  style: boldTextStyle(color: Colors.black),
                ),
                TextSpan(
                    text: 'Click here',
                    style: boldTextStyle(
                        color: Colors.indigo,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        String phone = dashboardStore.companyMobile.validate();
                        if (phone.isNotEmpty) {
                          String text =
                              'Please verify my mobile number ${appStore.userContactNumber.validate()}';
                          Uri uri = Uri.parse(
                              "https://api.whatsapp.com/send?phone=$phone&text=$text");
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          } else {
                            var error =
                                "WhatsApp is not installed. or some happend wrong";
                            toast(
                              error,
                              gravity: ToastGravity.TOP_RIGHT,
                              bgColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                        } else {
                          toast(
                            'Currently support is not available. Please try again later.',
                            gravity: ToastGravity.TOP,
                          );
                        }
                      }),
                TextSpan(
                  text: ' to complete the verification process.',
                  style: boldTextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildNotice(BuildContext context) {
    return Container(
      width: context.width(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.scaffoldBackgroundColor,
            Colors.indigo.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DEFAULT_RADIUS * 2),
      ),
      padding: const EdgeInsets.all(DEFAULT_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: context.width(),
            padding: const EdgeInsets.symmetric(
                horizontal: DEFAULT_PADDING / 2, vertical: DEFAULT_PADDING / 4),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
            ),
            child: Text('Notice',
                    style: boldTextStyle(color: Colors.white, size: 25))
                .center(),
          ),
          5.height,
          Text(
            dashboardStore.notice.validate(),
            style: boldTextStyle(color: Colors.black, size: 15),
          ),
        ],
      ),
    );
  }

  GridView buildLoadingGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      // itemCount: 10,
      padding:
          const EdgeInsets.only(top: DEFAULT_PADDING, bottom: DEFAULT_PADDING),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: DEFAULT_PADDING,
        mainAxisSpacing: DEFAULT_PADDING,
      ),
      itemBuilder: (context, index) {
        Game game = Game(
          id: 0,
          name: '--',
          title: '-------',
          timing: '-------',
          order: 00,
          today: 00,
          yesterday: 00,
        );
        String colorCode = generateColorCode(game.title.validate());
        // String colorCode = generateColorCode(index.toString());
        Color color = Color(int.parse(colorCode.replaceAll('#', '0xFF')));
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(DEFAULT_RADIUS * 2),
          ),
        ).skeletonize(enabled: true);
      },
    );
  }

  GridView buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dashboardStore.gamesList.length,
      // itemCount: 10,
      padding:
          const EdgeInsets.only(top: DEFAULT_PADDING, bottom: DEFAULT_PADDING),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: DEFAULT_PADDING,
        mainAxisSpacing: DEFAULT_PADDING,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        Game game = dashboardStore.gamesList[index];
        String colorCode = generateColorCode('${game.title.validate()}');
        // String colorCode = generateColorCode(index.toString());
        Color color = Color(int.parse(colorCode.replaceAll('#', '0xFF')));
        return Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(DEFAULT_RADIUS * 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: DEFAULT_PADDING / 2,
                        vertical: DEFAULT_PADDING / 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(DEFAULT_RADIUS * 2),
                    ),
                    child: Text(
                      '${game.title.validate()}(${game.name.validate()})',
                      style: boldTextStyle(color: Colors.white, size: 15),
                      textAlign: TextAlign.center,
                    ).center(),
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///today
                      Column(
                        children: [
                          Text('Today',
                              style: boldTextStyle(color: Colors.black87)),
                          1.height,
                          Text(
                            '${game.today.validate()}'.padLeft(2, '0'),
                            style: boldTextStyle(color: Colors.black, size: 20),
                          ),
                        ],
                      ).expand(),

                      ///yesterday
                      Column(
                        children: [
                          Text('Yesterday',
                              style: boldTextStyle(color: Colors.black87)),
                          1.height,
                          Text(
                            '${game.yesterday.validate()}'.padLeft(2, '0'),
                            style: boldTextStyle(color: Colors.black, size: 20),
                          ),
                        ],
                      ).expand(),
                    ],
                  ),
                ],
              ).paddingOnly(
                  left: DEFAULT_PADDING / 2,
                  right: DEFAULT_PADDING / 2,
                  top: DEFAULT_PADDING / 2),

              ///daily
              Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(DEFAULT_RADIUS * 2)),
                ),
                padding: const EdgeInsets.all(DEFAULT_PADDING / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 5,
                        children: [
                          Text('Daily:',
                              style: boldTextStyle(color: Colors.black87)),
                          Text(game.timing.validate(),
                              style: boldTextStyle(color: Colors.black87)),
                        ],
                      ),
                    ),
                    10.width,

                    /// fa icon share
                    const FaIcon(FontAwesomeIcons.shareNodes,
                            color: Colors.indigo)
                        .onTap(() {
                      AppShare.shareGame(
                        gameName: game.title.validate(),
                        gameTiming: game.timing.validate(),
                        today: game.today.validate().toString(),
                        yesterday: game.yesterday.validate().toString(),
                        list: dashboardStore.gamesList
                            .map((e) => e.title.validate())
                            .toList(),
                      );
                    }, borderRadius: BorderRadius.circular(DEFAULT_RADIUS * 2)),
                  ],
                ),
              ),

              ///
            ],
          ),
        );
      },
    );
  }
}
