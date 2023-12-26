import 'package:flutter/widgets.dart';
import 'package:homepad/pages/device_screen.dart';
import 'package:homepad/pages/floor_screen.dart';
import 'package:homepad/pages/room_screen.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
    this.name = '',
  });

  Widget? navigateScreen;
  String imagePath;
  String name;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/ic_room.svg',
      name: 'Device',
      navigateScreen: MyDevicePage(),
    ),
    HomeList(
      imagePath: 'assets/ic_room.svg',
      name: 'Sence ',
      navigateScreen: SizedBox(),
    ),
    HomeList(
      imagePath: 'assets/ic_floor.svg',
      name: 'Floor ',
      navigateScreen: MyFloorPage(),
    ),
    HomeList(
      imagePath: 'assets/ic_room.svg',
      name: 'Room  ',
      navigateScreen: MyRoomPage(),
    ),
  ];
}
