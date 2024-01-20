// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:coinxfiat/utils/utils_index.dart';
import 'package:coinxfiat/widgets/widget_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/component_index.dart';
import '../../../constants/constants_index.dart';
import '../../../routes/route_index.dart';
import '../../../services/service_index.dart';
import '../../../store/store_index.dart';

///drawer node id
ValueNotifier<String> _drawerNodeId = ValueNotifier<String>('');

///notification count
ValueNotifier<int> _notificationCount = ValueNotifier<int>(10);

class DashboardDrawer extends StatefulWidget {
  const DashboardDrawer({super.key});

  @override
  State<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  _showLogoutDialog() {
    showGeneralDialog(
        context: context,
        pageBuilder: (_, a1, a2) => ShadowedDialog(
              title: 'Logout',
              message: 'Are you sure you want to logout?',
              confirmText: 'Logout',
              onConfirm: () async {
                appStore.setLoading(true);
                var res = await AuthService().logout();
                // await 5.seconds.delay;
                appStore.setLoading(false);
                // LoadingWidget.showLoadingDialog(context);
                // context.goTo(LoginRoute());
                if (res) {
                  context.goNamed(Routes.login);
                }
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: const BoxConstraints(maxWidth: 300),
      child: Scaffold(
        extendBody: true,
        key: ValueKey(Random().nextInt(1000)),
        //     title: assetImages(MyPng.logoLWhite, fit: BoxFit.contain)
        //         .paddingAll(DEFAULT_PADDING)),
        body: Column(
          children: [
            Container(
              padding: EdgeInsetsDirectional.only(
                  top: MediaQuery.of(context).padding.top),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.theme.primaryColor,
                    context.accentColor,
                  ],
                ),
              ),
              child: assetImages(MyPng.logoLWhite, fit: BoxFit.contain)
                  .paddingAll(DEFAULT_PADDING),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  ///single jodi result
                  ListTile(
                    // tileColor: context.primaryColor.withOpacity(1),
                    onTap: () => context.pushNamed(Routes.mandiResult),
                    dense: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DEFAULT_RADIUS)),
                    leading:
                        const Icon(Icons.history_rounded, color: Colors.black),
                    minLeadingWidth: 0,
                    title: Text('Single Jodi Result',
                        style: boldTextStyle(color: Colors.black)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        size: 15, color: Colors.black),
                  ).paddingAll(DEFAULT_PADDING / 2),
                  Divider(thickness: 1, color: Colors.grey[300], height: 0),

                  /// Mondi result history
                  ListTile(
                    // tileColor: context.primaryColor.withOpacity(1),
                    onTap: () => context.pushNamed(Routes.singleJodi),
                    dense: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DEFAULT_RADIUS)),
                    leading:
                        const Icon(Icons.history_rounded, color: Colors.black),
                    minLeadingWidth: 0,
                    title: Text(
                      'Mondi Result History',
                      style: boldTextStyle(color: Colors.black),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        size: 15, color: Colors.black),
                  ).paddingAll(DEFAULT_PADDING / 2),
                  Divider(thickness: 1, color: Colors.grey[300], height: 0),

                  /// edit profile
                  ListTile(
                    // tileColor: context.primaryColor.withOpacity(1),
                    onTap: () {
                      context.pushNamed(Routes.editProfile);
                    },
                    dense: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DEFAULT_RADIUS)),
                    leading: const Icon(Icons.person, color: Colors.black),
                    minLeadingWidth: 0,
                    title: Text(
                      'Edit Profile',
                      style: boldTextStyle(color: Colors.black),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        size: 15, color: Colors.black),
                  ).paddingAll(DEFAULT_PADDING / 2),
                  Divider(thickness: 1, color: Colors.grey[300], height: 0),

                  /// change password
                  ListTile(
                    // tileColor: context.primaryColor.withOpacity(1),
                    onTap: () {
                      context.pushNamed(Routes.changePassword);
                    },
                    dense: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DEFAULT_RADIUS)),
                    leading: const Icon(Icons.lock, color: Colors.black),
                    minLeadingWidth: 0,
                    title: Text(
                      'Change Password',
                      style: boldTextStyle(color: Colors.black),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        size: 15, color: Colors.black),
                  ).paddingAll(DEFAULT_PADDING / 2),
                  Divider(thickness: 1, color: Colors.grey[300], height: 0),

                  ///Share App
                  ListTile(
                    // tileColor: context.primaryColor.withOpacity(1),
                    onTap: () {
                      AppShare.shareApp(
                        list: dashboardStore.gamesList
                            .map((e) => e.title.validate())
                            .toList(),
                      );
                    },
                    dense: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DEFAULT_RADIUS)),
                    leading: const Icon(Icons.share, color: Colors.black),
                    minLeadingWidth: 0,
                    title: Text(
                      'Share App',
                      style: boldTextStyle(color: Colors.black),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        size: 15, color: Colors.black),
                  ).paddingAll(DEFAULT_PADDING / 2),
                  Divider(thickness: 1, color: Colors.grey[300], height: 0),

                  ///Rate us
                  ListTile(
                    // tileColor: context.primaryColor.withOpacity(1),
                    onTap: () {
                      // AppReview.requestReview.then((value) {
                      //   print('value: $value');
                      // });
                    },
                    dense: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DEFAULT_RADIUS)),
                    leading: const Icon(Icons.star, color: Colors.black),
                    minLeadingWidth: 0,
                    title: Text(
                      'Rate Us',
                      style: boldTextStyle(color: Colors.black),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        size: 15, color: Colors.black),
                  ).paddingAll(DEFAULT_PADDING / 2),
                  Divider(thickness: 1, color: Colors.grey[300], height: 0),

                  ///logout
                  ListTile(
                    // tileColor: context.primaryColor.withOpacity(1),
                    onTap: () {
                      _showLogoutDialog();
                    },
                    dense: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DEFAULT_RADIUS)),
                    leading: const Icon(Icons.logout, color: Colors.black),
                    minLeadingWidth: 0,
                    title: Text(
                      'Logout',
                      style: boldTextStyle(color: Colors.black),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        size: 15, color: Colors.black),
                  ).paddingAll(DEFAULT_PADDING / 2),
                  (200).toInt().height,
                ],
              ),
            ),
          ],
        ),

        ///invite friends
        bottomNavigationBar: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(
                  top: DEFAULT_PADDING * 3,
                  left: DEFAULT_PADDING,
                  right: DEFAULT_PADDING,
                  bottom: DEFAULT_PADDING),
              padding: const EdgeInsets.all(DEFAULT_PADDING),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DEFAULT_RADIUS * 2),
                color: context.accentColor.withOpacity(0.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  (DEFAULT_PADDING * 2).toInt().height,
                  Text(
                    'Invite People and Earn',
                    textAlign: TextAlign.center,
                    style: boldTextStyle(
                        size: (APP_BAR_TEXT_SIZE).toInt(), color: Colors.white),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            AppShare.shareApp(
                              list: dashboardStore.gamesList
                                  .map((e) => e.title.validate())
                                  .toList(),
                            );
                          },
                          icon: const FaIcon(FontAwesomeIcons.shareNodes,
                                  color: Colors.indigo)
                              .paddingRight(DEFAULT_PADDING),
                          label: Text(
                            'Invite People',
                            style: TextStyle(
                                fontSize: APP_BAR_TEXT_SIZE.toDouble(),
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            ///invite image
            Positioned(
              right: 0,
              left: 0,
              top: 0,
              height: DEFAULT_PADDING * 5,
              child: assetImages(MyPng.referandearn,
                  fit: BoxFit.contain, height: 100),
            ),
          ],
        ).onTap(() {
          // context.pushNamed(Routes.referAndEarn);
          print('refer and earn');
        }),
      ),
    );
  }
}

class MyNode {
  const MyNode({
    required this.title,
    this.leading,
    this.trailing,
    this.icon,
    this.openedIcon,
    this.closedIcon,
    this.children = const <MyNode>[],
  });
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final List<MyNode> children;

  final IconData? icon;
  final IconData? openedIcon;
  final IconData? closedIcon;
}

class DrawerItemsTree extends StatefulWidget {
  const DrawerItemsTree({super.key, this.loading = false});
  final bool loading;
  @override
  State<DrawerItemsTree> createState() => _DrawerItemsTreeState();
}

class _DrawerItemsTreeState extends State<DrawerItemsTree> {
  late List<MyNode> roots;
  late final TreeController<MyNode> treeController;

  @override
  void initState() {
    super.initState();
    roots = <MyNode>[
      MyNode(
        title: 'Trade List',
        icon: FontAwesomeIcons.rightLeft,
        openedIcon: FontAwesomeIcons.rightLeft,
        closedIcon: FontAwesomeIcons.rightLeft,
        children: <MyNode>[
          MyNode(
            title: 'Running',
            trailing: ValueListenableBuilder(
                valueListenable: _notificationCount,
                builder: (context, int value, _) {
                  return Badge(
                    isLabelVisible: widget.loading ? false : value > 0,
                    backgroundColor: Colors.transparent,
                    label: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(value.toString(),
                          style: const TextStyle(color: Colors.white)),
                    ),
                  );
                }),
            children: <MyNode>[],
          ),
          const MyNode(title: 'Completed'),
        ],
      ),
      const MyNode(
        title: 'Walkthrough List',
        icon: FontAwesomeIcons.list,
        openedIcon: FontAwesomeIcons.listOl,
        closedIcon: FontAwesomeIcons.listUl,
        children: <MyNode>[
          MyNode(title: 'Setup Wallet', children: <MyNode>[]),
          MyNode(title: 'Binance Exchange'),
          MyNode(title: 'Zebpay Exchange'),
        ],
      ),

      /// My Holding
      const MyNode(
        title: 'My Holding',
        children: <MyNode>[],
        icon: FontAwesomeIcons.wallet,
      ),

      ///transaction
      const MyNode(
        title: 'Transaction List',
        children: <MyNode>[],
        icon: FontAwesomeIcons.moneyBill,
      ),

      ///payout history
      const MyNode(
          title: 'Payout History',
          children: <MyNode>[],
          icon: FontAwesomeIcons.clockRotateLeft),

      ///supoort tickets
      const MyNode(
          title: 'Support Tickets',
          children: <MyNode>[],
          icon: Icons.support_agent_outlined),

      ///about us
      const MyNode(title: 'About Us', children: <MyNode>[], icon: Icons.info),

      ///settings
      const MyNode(
          title: 'Settings', children: <MyNode>[], icon: Icons.settings),

      ///terms and conditions
      const MyNode(
          title: 'Terms & Conditions',
          children: <MyNode>[],
          icon: Icons.description),

      ///privacy policy
      const MyNode(
          title: 'Privacy Policy', children: <MyNode>[], icon: Icons.policy),

      ///logout button
      const MyNode(title: 'Logout', children: <MyNode>[], icon: Icons.logout),
    ];
    treeController = TreeController<MyNode>(
        roots: roots, childrenProvider: (MyNode node) => node.children);
    treeController.expandAll();
    _drawerNodeId.addListener(_goThrough);
  }

  void _goThrough() {
    String nodeId = _drawerNodeId.value;
    if (nodeId.isNotEmpty) {
      switch (nodeId) {
        case 'Running':
          context.push(Paths.tradeList('running', null));
          _notificationCount.value++;
          break;
        case 'Completed':
          context.push(Paths.tradeList('complete', null));
          break;
        case 'Setup Wallet':
          context.pushNamed(Routes.htmlPage, queryParameters: {
            'title': 'Setup Wallet',
            'html': setupWalletHTML,
          });
          break;
        case 'Binance Exchange':
          context.pushNamed(Routes.htmlPage, queryParameters: {
            'title': 'Binance Exchange',
            'html': binanceHTML,
          });
          break;
        case 'Zebpay Exchange':
          context.pushNamed(Routes.htmlPage, queryParameters: {
            'title': 'Zebpay Exchange',
            'html': zebpayHTML,
          });
          break;
        case 'My Holding':
          context.pushNamed(Routes.myHoldings);
          _drawerNodeId.value = '';
          break;
        case 'Transaction List':
          context.pushNamed(Routes.transactionHistory);
          _drawerNodeId.value = '';
          break;
        case 'Payout History':
          context.pushNamed(Routes.payoutHistory);
          _drawerNodeId.value = '';
          break;
        case 'Support Tickets':
          context.pushNamed(Routes.support);
          _drawerNodeId.value = '';
          break;
        case 'About Us':
          context.pushNamed(Routes.aboutUs);
          _drawerNodeId.value = '';
          break;
        case 'Settings':
          break;
        case 'Logout':
          _showLogoutDialog();
          _drawerNodeId.value = '';
          break;
        case 'Terms & Conditions':
          context.pushNamed(Routes.htmlPage, queryParameters: {
            'title': 'Terms & Conditions',
            'html': termsAndConditionsHTML,
          });
          break;
        case 'Privacy Policy':
          context.pushNamed(Routes.htmlPage, queryParameters: {
            'title': 'Privacy Policy',
            'html': privatePolicyHTML,
          });
          break;
        default:
      }
      _drawerNodeId.value = '';
    }
  }

  _showLogoutDialog() {
    showGeneralDialog(
        context: context,
        pageBuilder: (_, a1, a2) => ShadowedDialog(
              title: 'Logout',
              message: 'Are you sure you want to logout?',
              confirmText: 'Logout',
              onConfirm: () async {
                appStore.setLoading(true);
                var res = await AuthService().logout();
                // await 5.seconds.delay;
                appStore.setLoading(false);
                // LoadingWidget.showLoadingDialog(context);
                // context.goTo(LoginRoute());
                if (res) {
                  context.goNamed(Routes.login);
                }
              },
            ));
  }

  @override
  void dispose() {
    treeController.dispose();
    _drawerNodeId.value = '';
    _drawerNodeId.removeListener(_goThrough);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TreeView<MyNode>(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(DEFAULT_PADDING),
      treeController: treeController,
      shrinkWrap: true,
      nodeBuilder: (BuildContext context, TreeEntry<MyNode> entry) {
        return MyTreeTile(
            key: ValueKey(entry.node),
            entry: entry,
            onTap: () => treeController.toggleExpansion(entry.node));
      },
    );
  }
}

class MyTreeTile extends StatelessWidget {
  const MyTreeTile({super.key, required this.entry, required this.onTap});

  final TreeEntry<MyNode> entry;
  final VoidCallback onTap;

  void _goThrough() {
    // print('entry.node.title: ${entry.node.title}');
  }

  @override
  Widget build(BuildContext context) {
    double indentWidth = 30;
    double intendPadding = DEFAULT_PADDING / 2;
    return InkWell(
      onTap: () {
        !entry.hasChildren ? _goThrough() : onTap();
        _drawerNodeId.value = entry.node.title;
      },
      child: TreeIndentation(
        entry: entry,
        guide: IndentGuide.connectingLines(
          indent: indentWidth + intendPadding,
          roundCorners: false,
          padding: const EdgeInsetsDirectional.all(0),
          color: context.theme.brightness == Brightness.light
              ? Colors.grey.shade300
              : Colors.grey.shade700,
          thickness: indentWidth / 15,
          origin: 0.5,
        ),
        child: ValueListenableBuilder(
            valueListenable: _drawerNodeId,
            builder: (context, String value, _) {
              return Container(
                padding: EdgeInsets.all(intendPadding),
                decoration: BoxDecoration(
                  color: entry.node.title == value
                      ? context.theme.primaryColor.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        IndentWidget(
                          isOpen: entry.hasChildren ? entry.isExpanded : null,
                          onPressed: entry.hasChildren ? onTap : null,
                          padding: EdgeInsets.only(
                              right: entry.hasChildren
                                  ? indentWidth / 3
                                  : entry.node.icon != null
                                      ? indentWidth / 3
                                      : 0),
                          icon: entry.node.icon != null
                              ? FaIcon(entry.node.icon, size: indentWidth / 2)
                              : const SizedBox(),
                          openedIcon: FaIcon(
                              entry.node.openedIcon ?? Icons.arrow_drop_down,
                              size: indentWidth / 2),
                          closedIcon: FaIcon(
                              entry.node.closedIcon ?? Icons.arrow_right,
                              size: indentWidth / 2),
                        ),
                        AnimatedPadding(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsetsDirectional.all(
                                !entry.hasChildren && value == entry.node.title
                                    ? 0
                                    : 0),
                            child: Text(entry.node.title)),
                      ],
                    ),

                    //// This is the badge
                    if (entry.node.trailing != null)
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: entry.node.trailing!,
                      ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class IndentWidget extends StatelessWidget {
  const IndentWidget({
    super.key,
    this.isOpen,
    this.onPressed,
    this.padding,
    this.icon,
    this.openedIcon,
    this.closedIcon,
  });

  final bool? isOpen;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final Widget? icon;
  final Widget? openedIcon;
  final Widget? closedIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: padding ?? const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: isOpen == null
            ? icon
            : isOpen!
                ? openedIcon
                : closedIcon,
      ),
    );
  }
}
