import 'package:flutter/material.dart';
import 'package:homepad/pages/floor_screen.dart';
import 'package:homepad/pages/room_screen.dart';
import 'package:homepad/theme/app_theme.dart';

import 'custom_drawer/drawer_user_controller.dart';
import 'custom_drawer/home_drawer.dart';
import 'pages/home_screen.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = const MyHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.25,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
            },
            screenView: screenView,
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = const MyHomePage();
          });
          break;
        case DrawerIndex.Floor:
          setState(() {
            screenView = MyFloorPage();
          });
          break;
        case DrawerIndex.Room:
          setState(() {
            screenView = MyRoomPage();
          });
          break;
        case DrawerIndex.About:
          setState(() {
            screenView = Container();
          });
          break;
        default:
          break;
      }
    }
  }
}
