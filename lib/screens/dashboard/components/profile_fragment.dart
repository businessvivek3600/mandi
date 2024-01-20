import 'package:coinxfiat/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constants/constants_index.dart';
import '../../../routes/route_index.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //// app bar with back gound banner image
          /// a stacked uer profile image and name and email
          _appBar(context),

          ///First Name Sumit Last Name Sharma Username SumitSharma Email Address sumit9451sharma@gmail.com Phone Number 7007959656 Preferred Language English Address
          ///with prefix fa icon and edit icon with appropriate color and size
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(DEFAULT_PADDING),
              decoration: const BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///First Name
                  _profileItem(
                    context,
                    title: 'First Name',
                    subTitle: 'Sumit',
                    prefixIcon: FontAwesomeIcons.user,
                  ),

                  ///Last Name
                  _profileItem(
                    context,
                    title: 'Last Name',
                    subTitle: 'Sharma',
                    prefixIcon: FontAwesomeIcons.user,
                  ),

                  ///Username
                  _profileItem(
                    context,
                    title: 'Username',
                    subTitle: 'SumitSharma',
                    prefixIcon: FontAwesomeIcons.user,
                  ),

                  ///Email Address
                  _profileItem(
                    context,
                    title: 'Email Address',
                    subTitle: ' ',
                    prefixIcon: FontAwesomeIcons.envelope,
                  ),

                  ///Phone Number
                  _profileItem(
                    context,
                    title: 'Phone Number',
                    subTitle: '7007959656',
                    prefixIcon: FontAwesomeIcons.phone,
                  ),

                  ///Preferred Language
                  _profileItem(
                    context,
                    title: 'Preferred Language',
                    subTitle: 'English',
                    prefixIcon: FontAwesomeIcons.language,
                  ),

                  ///Address
                  _profileItem(
                    context,
                    title: 'Address',
                    subTitle: ' ',
                    prefixIcon: FontAwesomeIcons.locationDot,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileItem(BuildContext context,
      {required String title,
      required String subTitle,
      required IconData prefixIcon}) {
    return Container(
      margin: const EdgeInsets.only(top: DEFAULT_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///title
          Text(title, style: boldTextStyle(color: context.accentColor)),
          height5(),
          Container(
            decoration: BoxDecoration(
              color: context.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
            ),
            padding: const EdgeInsets.all(DEFAULT_PADDING),
            child: Row(
              children: [
                ///prefix icon
                FaIcon(prefixIcon, color: context.accentColor, size: 16),
                width5(),

                ///sub title
                Expanded(
                  child: Text(subTitle,
                      style: boldTextStyle(color: context.accentColor)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _appBar(BuildContext context) {
    String userName = 'User Name';
    return SliverAppBar(
      expandedHeight: context.height() * 0.2,
      collapsedHeight: context.height() * 0.1,
      backgroundColor: context.accentColor,
      elevation: 0,
      pinned: true,
      centerTitle: false,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          expandedTitleScale: 1.0,
          background: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [context.accentColor, context.primaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Stack(
              // fit: StackFit.expand,
              children: [
                Container(
                  margin: const EdgeInsetsDirectional.symmetric(
                      horizontal: DEFAULT_PADDING),
                  height: context.height() * 0.2,
                  width: context.width(),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: assetImageProvider(MyPng.logoLWhite),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),

          ///title
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                // height: context.height() * 0.08,
                width: context.width(),
                padding: const EdgeInsetsDirectional.only(
                    start: DEFAULT_PADDING, end: DEFAULT_PADDING),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ///user profile image
                    Container(
                      height: context.height() * 0.08,
                      width: context.height() * 0.08,
                      decoration: BoxDecoration(
                        color: context.primaryColor,
                        shape: BoxShape.circle,
                        // borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
                        image: DecorationImage(
                          image: assetImageProvider(MyPng.logoLWhite),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    width10(DEFAULT_PADDING),

                    ///user name and email
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: boldTextStyle(
                                size: 16,
                                letterSpacing: 1,
                                color: Colors.white),
                          ),
                          height5(),
                          capText('user@gmail.com', context,
                              color: Colors.white70)
                        ],
                      ),
                    ),

                    ///edit profile
                    IconButton(
                      onPressed: () => context.pushNamed(Routes.editProfile),
                      icon: const FaIcon(FontAwesomeIcons.penToSquare,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
