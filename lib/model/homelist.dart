import 'package:flutter/widgets.dart';

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
      name: '房间管理',
      navigateScreen: Container(),
    ),
    HomeList(
      imagePath: 'assets/ic_room.svg',
      name: '设备管理',
      navigateScreen: Container(),
    ),
    HomeList(
      imagePath: 'assets/ic_room.svg',
      name: '...',
      navigateScreen: Container(),
    ),
    HomeList(
      imagePath: 'assets/ic_room.svg',
      name: '...',
      navigateScreen: Container(),
    ),
  ];
}
