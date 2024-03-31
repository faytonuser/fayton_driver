import 'package:driver/common/assets.dart';
import 'package:driver/models/profile_model.dart';
import 'package:driver/providers/auth_provider.dart';
import 'package:driver/providers/navbar_provider.dart';
import 'package:driver/screens/home_screen.dart';
import 'package:driver/screens/message_list_screen.dart';
import 'package:driver/screens/new_profile_screen.dart';
import 'package:driver/screens/profile_screen.dart';
import 'package:driver/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class CustomNavigationBar extends StatefulWidget {
  final ProfileModel? currentUser;
  const CustomNavigationBar({super.key, required this.currentUser});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  void initState() {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authProvider.currentUser = widget.currentUser;
    });
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ).then((value) {
      AuthService.setLocation(
          authProvider.currentUser!.userId, value.latitude, value.longitude);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var navbarProvider = Provider.of<NavbarProvider>(context);
    return PersistentTabView(
      context,
      controller: navbarProvider.tabController,
      screens: [
        HomeScreen(),
        MessageListScreen(),
        NewProfileScreen(),
      ],
      items: [
        PersistentBottomNavBarItem(
          icon: Image.asset(
            AssetPaths.logo,
          ),
          title: ("Home"),
          activeColorPrimary: CupertinoColors.activeBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.message),
          title: ("Messages"),
          activeColorPrimary: CupertinoColors.activeBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.person),
          title: ("Profile"),
          activeColorPrimary: CupertinoColors.activeBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ],
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}
