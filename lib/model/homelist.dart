import 'package:flutter/widgets.dart';
import 'package:homepad/pages/scene_screen.dart';
import 'package:homepad/pages/vcr_screen.dart';
import 'package:homepad/pages/area_screen.dart';
import 'package:homepad/pages/camera_screen.dart';

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
      name: 'Vcr   ',
      navigateScreen: MyVcrPage(),
    ),
    HomeList(
      imagePath: 'assets/ic_room.svg',
      name: 'Sence ',
      navigateScreen: MyScenePage(),
    ),
    HomeList(
      imagePath: 'assets/ic_floor.svg',
      name: 'Area  ',
      navigateScreen: MyAreaPage(),
    ),
    HomeList(
      imagePath: 'assets/ic_room.svg',
      name: 'Camera',
      navigateScreen: MyCameraPage(),
    ),
  ];
}
