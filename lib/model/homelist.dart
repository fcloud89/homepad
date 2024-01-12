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
      imagePath: 'assets/imgs/ic_floor.svg',
      name: 'Area',
      navigateScreen: MyAreaPage(),
    ),
    HomeList(
      imagePath: 'assets/imgs/ic_camera.svg',
      name: 'Camera',
      navigateScreen: MyCameraPage(),
    ),
    HomeList(
      imagePath: 'assets/imgs/ic_record.svg',
      name: 'Vcr',
      navigateScreen: MyVcrPage(),
    ),
    HomeList(
      imagePath: 'assets/imgs/ic_setting.svg',
      name: 'Setting',
      navigateScreen: MyScenePage(),
    ),
  ];
}
