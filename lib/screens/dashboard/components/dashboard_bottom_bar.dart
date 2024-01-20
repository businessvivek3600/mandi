import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constants/constants_index.dart';

class DashBoardBottomNavBar extends StatelessWidget {
  const DashBoardBottomNavBar(
      {super.key,
      required this.onDestinationSelected,
      required this.currentIndex});

  final void Function(int index) onDestinationSelected;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: Platform.isIOS || Platform.isMacOS
              ? kBottomNavigationBarHeight / 2
              : 0),
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(DEFAULT_RADIUS * 2),
            topRight: Radius.circular(DEFAULT_RADIUS * 2)),
        // gradient: appBarGradient(context),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(3, 2) // changes position of shadow
              )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ..._icons.asMap().entries.map((e) => AnimatedSize(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              child: FaIcon(e.value,
                      color: currentIndex == e.key
                          ? context.primaryColor
                          : context.accentColor,
                      size: currentIndex == e.key ? 30 : 25)
                  .paddingAll(DEFAULT_PADDING)
                  .onTap(() => onDestinationSelected(e.key))
              // .scale(scale: currentIndex == e.key ? 1.1 : 1),
              )),
        ],
      ),
    );
  }

  List<IconData> get _icons => [
        FontAwesomeIcons.houseUser,
        FontAwesomeIcons.wallet,
        FontAwesomeIcons.rectangleAd,
        FontAwesomeIcons.user,
      ];
}
