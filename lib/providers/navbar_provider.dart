import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class NavbarProvider extends ChangeNotifier {
  final PersistentTabController _tabController = PersistentTabController();
  PersistentTabController get tabController => _tabController;
}
