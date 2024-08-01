import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class NavbarProvider extends ChangeNotifier {
  final PersistentTabController _tabController = PersistentTabController();
  PersistentTabController get tabController => _tabController;
}
