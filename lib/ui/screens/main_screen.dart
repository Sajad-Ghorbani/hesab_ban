import 'package:hesab_ban/ui/screens/home_screen.dart';
import 'package:hesab_ban/ui/screens/all_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hesab_ban/ui/screens/select_factor_screen.dart';
import 'package:hesab_ban/ui/screens/setting_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../controllers/home_controller.dart';
import '../theme/app_colors.dart';

class MainScreen extends GetView<HomeController> {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        screens: const [
          HomeScreen(),
          AllProductScreen(),
          SelectFactorScreen(),
          SettingScreen(),
        ],
        controller: controller.pageController,
        items: [
          PersistentBottomNavBarItem(
            icon: const Icon(FontAwesomeIcons.home),
            activeColorPrimary: kBlueColor,
            inactiveColorPrimary: kGreyColor,
            title: 'صفحه اصلی',
          ),
          PersistentBottomNavBarItem(
            icon: const Icon(FontAwesomeIcons.boxOpen),
            activeColorPrimary: kPurpleColor,
            inactiveColorPrimary: kGreyColor,
            title: 'کالاها',
          ),
          PersistentBottomNavBarItem(
            icon: const Icon(FontAwesomeIcons.fileInvoice),
            activeColorPrimary: kPinkColor,
            inactiveColorPrimary: kGreyColor,
            title: 'فاکتور',
          ),
          PersistentBottomNavBarItem(
            icon: const Icon(FontAwesomeIcons.cogs),
            activeColorPrimary: kRedColor,
            inactiveColorPrimary: kGreyColor,
            title: 'تنظیمات',
          ),
        ],
        confineInSafeArea: true,
        backgroundColor: kSurfaceColor,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(60),
          colorBehindNavBar: kBackgroundColor,
          gradient: LinearGradient(colors: [
            kDarkGreyColor.withOpacity(0.6),
            kSurfaceColor.withOpacity(0.6),
          ]),
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style6,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        navBarHeight: 60,
        onWillPop: (context) async {
          return controller.willPop();
        },
      ),
    );
  }
}
