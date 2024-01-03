import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepad/model/homelist.dart';
import 'package:homepad/model/msg_list_data.dart';
import 'package:homepad/pages/Notice_list_view.dart';
import 'package:homepad/pages/camera_screen.dart';
import 'package:homepad/utils/RouteHelper.dart';
import 'package:homepad/widgets/MTextField.dart';
import 'package:homepad/widgets/WCustomDialog.dart';
import 'package:homepad/widgets/digital_clock/slide_digital_clock.dart';
import 'package:homepad/widgets/fwidget/stateful.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController? animationController;
  List<HotelListData> hotelList = HotelListData.hotelList;
  List<HomeList> homeList = HomeList.homeList;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF1C2B3C),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(50),
        child: Row(
          children: [
            SizedBox(
              width: w * 0.4,
              child: Column(
                children: [
                  Expanded(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          height: h / 4.2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.shade200.withOpacity(0.3)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.05),
                  Expanded(
                    flex: 2,
                    child: GridView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 40.0,
                        crossAxisSpacing: 40.0,
                        childAspectRatio: 1.4,
                      ),
                      children: List<Widget>.generate(
                        homeList.length,
                        (int index) {
                          final int count = homeList.length;
                          final Animation<double> animation =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn),
                            ),
                          );
                          animationController?.forward();
                          return HomeListView(
                            animation: animation,
                            animationController: animationController,
                            listData: homeList[index],
                            callBack: () {
                              RouteHelper.pushWidget(
                                  context, homeList[index].navigateScreen!);
                            },
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: w * 0.046),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Color(0xff2e4861).withOpacity(1)),
                      child: DigitalClock(
                        digitAnimationStyle: Curves.elasticOut,
                        is24HourTimeFormat: false,
                        areaAligment: AlignmentDirectional.center,
                        areaDecoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        hourMinuteDigitDecoration: const BoxDecoration(),
                        hourMinuteDigitTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 220,
                        ),
                        secondDigitDecoration: const BoxDecoration(),
                        amPmDigitTextStyle: const TextStyle(
                            fontSize: 60,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.05),
                  Expanded(
                      flex: 2,
                      child: Container(
                        height: h / 3,
                        child: ListView.builder(
                          itemCount: hotelList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            final int count =
                                hotelList.length > 10 ? 10 : hotelList.length;
                            final Animation<double> animation =
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                        parent: animationController!,
                                        curve: Interval(
                                            (1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn)));
                            animationController?.forward();
                            return NoticeListView(
                              callback: () {},
                              hotelData: hotelList[index],
                              animation: animation,
                              animationController: animationController!,
                            );
                          },
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class HomeListView extends StatelessWidget {
  const HomeListView(
      {Key? key,
      this.listData,
      this.callBack,
      this.animationController,
      this.animation})
      : super(key: key);

  final HomeList? listData;
  final VoidCallback? callBack;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext bct, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: btns(bct, listData),
          ),
        );
      },
    );
  }

  Widget btns(BuildContext bct, HomeList? listData) {
    return NeumorphicButton(
      padding: EdgeInsets.zero,
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(12),
        ),
        color: Colors.transparent,
        shape: NeumorphicShape.flat,
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration:
                  BoxDecoration(color: const Color(0xffe4edd5).withOpacity(1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    listData!.imagePath,
                    width: 80,
                    height: 80,
                    colorFilter: const ColorFilter.mode(
                        Color(0xFFCD703F), BlendMode.srcIn),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      listData!.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 32,
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
      onPressed: () {
        callBack?.call();
      },
    );
  }
}
