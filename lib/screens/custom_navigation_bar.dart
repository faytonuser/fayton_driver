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
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

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
          authProvider.currentUser?.userId ?? "", value.latitude, value.longitude);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var navbarProvider = Provider.of<NavbarProvider>(context);
    return PersistentTabView(
      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
      ),
      controller: navbarProvider.tabController,
      tabs: [
        PersistentTabConfig(
          screen: HomeScreen(),
          item: ItemConfig(
            icon: Image.asset(
              AssetPaths.logo,
            ),
            title: ("Home"),
            activeForegroundColor: CupertinoColors.activeBlue,
            inactiveBackgroundColor: CupertinoColors.systemGrey,
          ),
        ),
        PersistentTabConfig(
          screen: MessageListScreen(),
          item: ItemConfig(
            icon: Icon(Icons.message),
            title: ("Messages"),
            activeForegroundColor: CupertinoColors.activeBlue,
            inactiveBackgroundColor: CupertinoColors.systemGrey,
          ),
        ),
        PersistentTabConfig(
          screen: NewProfileScreen(),
          item: ItemConfig(
            icon: Icon(CupertinoIcons.person),
            title: ("Profile"),
            activeForegroundColor: CupertinoColors.activeBlue,
            inactiveBackgroundColor: CupertinoColors.systemGrey,
          ),
        ),
      ],
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,

      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,

      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      // Choose the nav bar style with this property.
    );
  }
}
