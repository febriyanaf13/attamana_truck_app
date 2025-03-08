import 'package:attamana_truck_app/app/modules/account/views/account_view.dart';
import 'package:attamana_truck_app/app/modules/history/views/history_view.dart';
import 'package:attamana_truck_app/app/modules/home/views/home_view.dart';
import 'package:attamana_truck_app/app/utils/extension_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../style/colors.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    DateTime timeBackPressed = DateTime.now();
    return WillPopScope(
        onWillPop: () async {
          final differeance = DateTime.now().difference(timeBackPressed);
          timeBackPressed = DateTime.now();
          if (differeance >= const Duration(seconds: 2)) {
            if (controller.tabController.value.index == 0) {
              const String msg = 'Press the back button to exit';
              Fluttertoast.showToast(
                msg: msg,
              );
            } else {
              controller.tabController.value.index = 0;
            }
            return false;
          } else {
            Fluttertoast.cancel();
            SystemNavigator.pop();
            return true;
          }
        },
        child:Obx(()=> PersistentTabView(
          context,
          controller: controller.tabController.value,
          screens: _buildScreens(),
          items: _navBarsItems(),
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          hideNavigationBarWhenKeyboardAppears: true,
          padding: const EdgeInsets.all(10),
          backgroundColor: Colors.white,
          isVisible: true,
          animationSettings: const NavBarAnimationSettings(
            navBarItemAnimation: ItemAnimationSettings(
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimationSettings(
              animateTabTransition: true,
              duration: Duration(milliseconds: 200),
              screenTransitionAnimationType:
                  ScreenTransitionAnimationType.fadeIn,
            ),
          ),
          confineToSafeArea: true,
          navBarHeight: kBottomNavigationBarHeight,
          navBarStyle: NavBarStyle.style6,
        )));
  }

  List<Widget> _buildScreens() {
    return [
      const HomeView(),
      const HistoryView(),
      const AccountView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.home),
          title: ("Home"),
          activeColorPrimary: kPrimaryColor,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          iconSize: 20),
      PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.doc_text_search),
          title: ("History"),
          activeColorPrimary: kPrimaryColor,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          iconSize: 20),
      PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.profile_circled),
          title: ("Account"),
          activeColorPrimary: kPrimaryColor,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          iconSize: 20),
    ];
  }
}
