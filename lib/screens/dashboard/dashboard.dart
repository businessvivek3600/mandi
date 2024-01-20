import 'package:coinxfiat/constants/constants_index.dart';
import 'package:coinxfiat/store/store_index.dart';
import 'package:coinxfiat/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../screen_index.dart';

final GlobalKey<ScaffoldState> dashboardScaffoldKey =
    GlobalKey<ScaffoldState>();

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  int currentIndex = 0;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void _onDestinationSelected(int index) =>
      setState(() => currentIndex = index);

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {});
    // init();
  }

  Future<bool> onWillPop() async {
    if (currentIndex != 0) {
      _onDestinationSelected(0);
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      onWillPop: onWillPop,
      child: Scaffold(
        key: dashboardScaffoldKey,
        backgroundColor:
            context.theme.secondaryHeaderColor.withOpacity(0.0000001),
        appBar: AppBar(
          title: Text(AppConst.appName,
              style: boldTextStyle(color: Colors.white, size: 20)),
          centerTitle: false,
          // leading: IconButton(
          //   icon: const Icon(Icons.menu),
          //   onPressed: () {
          //     dashboardScaffoldKey.currentState?.openDrawer();
          //   },
          // ),
          actions: [
            Text(appStore.userName.validate(),
                    style: boldTextStyle(color: Colors.white))
                .center()
                .paddingOnly(right: DEFAULT_PADDING),
          ],
        ),
        drawer: const DashboardDrawer(),
        // body: AnimatedScrollView(
        //   padding: const EdgeInsets.only(
        //     left: DEFAULT_PADDING,
        //     right: DEFAULT_PADDING,
        //     bottom: DEFAULT_PADDING + kToolbarHeight,
        //   ),
        //   children: [
        //     GridView.builder(
        //       shrinkWrap: true,
        //       itemCount: 10,
        //       padding: const EdgeInsets.only(
        //           top: DEFAULT_PADDING, bottom: DEFAULT_PADDING),
        //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 2,
        //         crossAxisSpacing: DEFAULT_PADDING,
        //         mainAxisSpacing: DEFAULT_PADDING,
        //       ),
        //       itemBuilder: (context, index) {
        //         String colorCode = generateColorCode(index.toString());
        //         Color color =
        //             Color(int.parse(colorCode.replaceAll('#', '0xFF')));
        //         return Container(
        //             decoration: BoxDecoration(
        //               color: color.withOpacity(0.1),
        //               borderRadius: BorderRadius.circular(DEFAULT_RADIUS * 2),
        //             ),
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 Column(
        //                   children: [
        //                     Text(
        //                       'Gaziabad(GH)',
        //                       style: boldTextStyle(color: color, size: 22),
        //                       textAlign: TextAlign.center,
        //                     ).center(),
        //                     const Divider(thickness: 1, color: Colors.grey),
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: [
        //                         ///today
        //                         Column(
        //                           children: [
        //                             Text(
        //                               'Today',
        //                               style:
        //                                   boldTextStyle(color: Colors.black87),
        //                             ),
        //                             1.height,
        //                             Text(
        //                               '00',
        //                               style: boldTextStyle(
        //                                   color: Colors.grey, size: 20),
        //                             ),
        //                           ],
        //                         ).expand(),

        //                         ///yesterday
        //                         Column(
        //                           children: [
        //                             Text(
        //                               'Yesterday',
        //                               style:
        //                                   boldTextStyle(color: Colors.black87),
        //                             ),
        //                             1.height,
        //                             Text(
        //                               '00',
        //                               style: boldTextStyle(
        //                                   color: Colors.grey, size: 20),
        //                             ),
        //                           ],
        //                         ).expand(),
        //                       ],
        //                     ),
        //                   ],
        //                 ).paddingOnly(
        //                     left: DEFAULT_PADDING / 2,
        //                     right: DEFAULT_PADDING / 2,
        //                     top: DEFAULT_PADDING / 2),

        //                 ///daily
        //                 Container(
        //                   decoration: BoxDecoration(
        //                     color: color.withOpacity(0.3),
        //                     borderRadius: const BorderRadius.vertical(
        //                       bottom: Radius.circular(DEFAULT_RADIUS * 2),
        //                     ),
        //                   ),
        //                   padding: const EdgeInsets.all(DEFAULT_PADDING),
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       Expanded(
        //                         child: Text(
        //                           'Daily: ${MyDateUtils.formatDateAsToday(DateTime.now())}',
        //                           style: boldTextStyle(color: Colors.black87),
        //                         ),
        //                       ),
        //                       10.width,

        //                       /// fa icon share
        //                       const FaIcon(FontAwesomeIcons.shareNodes,
        //                               color: Colors.indigo)
        //                           .onTap(() {},
        //                               borderRadius: BorderRadius.circular(
        //                                   DEFAULT_RADIUS * 2)),
        //                     ],
        //                   ),
        //                 ),

        //                 ///
        //               ],
        //             ));
        //       },
        //     ),
        //     Container(
        //       height: context.height(),
        //       child: Column(
        //         children: [
        //           Container(
        //             height: context.height() * 0.3,
        //             width: context.width(),
        //             color: Colors.red,
        //           ),
        //           Container(
        //             height: context.height() * 0.7,
        //             width: context.width(),
        //             color: Colors.blue,
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),

        body:
            // [
            const DashboardFragment(),
        //   const WalletFragment(),
        //   const AdvertisementFragment(),
        //   const ProfileFragment()
        // ][0],
        // bottomNavigationBar: DashBoardBottomNavBar(
        //   onDestinationSelected: _onDestinationSelected,
        // currentIndex: currentIndex,
        // ),
      ),
    );
  }
}
