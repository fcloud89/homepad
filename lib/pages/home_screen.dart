import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepad/model/homelist.dart';
import 'package:homepad/model/msg_list_data.dart';
import 'package:homepad/pages/hotel_list_view.dart';
import 'package:homepad/widgets/TextField.dart';
import 'package:homepad/widgets/WCustomDialog.dart';
import 'package:homepad/widgets/fwidget/stateful.dart';

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
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(50),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: w * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 124, right: 50),
                      child: NeumorphicButton(
                        padding: const EdgeInsets.all(14),
                        style: const NeumorphicStyle(
                          shadowLightColor: Color(0x8A000000),
                          shadowDarkColor: Color(0x8A000000),
                          boxShape: NeumorphicBoxShape.circle(),
                          shape: NeumorphicShape.flat,
                          depth: 10,
                          // intensity: 5,
                        ),
                        child: const Icon(
                          Icons.ring_volume,
                          color: Colors.black,
                          size: 48,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    NeumorphicButton(
                      padding: const EdgeInsets.all(14),
                      style: const NeumorphicStyle(
                        shadowLightColor: Color(0x8A000000),
                        shadowDarkColor: Color(0x8A000000),
                        boxShape: NeumorphicBoxShape.circle(),
                        shape: NeumorphicShape.flat,
                        depth: 10,
                        // intensity: 5,
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: Colors.black,
                        size: 48,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
                // const Expanded(child: SizedBox()),
                Expanded(
                  child: GridView(
                    reverse: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 40.0,
                      crossAxisSpacing: 40.0,
                      childAspectRatio: 1.93,
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
                            // Navigator.push<dynamic>(
                            //   context,
                            //   MaterialPageRoute<dynamic>(
                            //     builder: (BuildContext context) =>
                            //         homeList[index].navigateScreen!,
                            //   ),
                            // );
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: w * 0.012),
                    Container(
                      margin: EdgeInsets.only(top: h * 0.018),
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            height: h / 1.93,
                            width: w / 3.9,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.grey.shade200.withOpacity(0.3)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: w * 0.03),
                    Expanded(
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            height: h / 5.2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.grey.shade200.withOpacity(0.3)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
                // ClipRect(
                //   child: BackdropFilter(
                //     filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                //     child: Container(
                //       height: MediaQuery.of(context).size.height / 4.2,
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(20.0),
                //           color: Colors.grey.shade200.withOpacity(0.3)),
                //     ),
                //   ),
                // ),
                Container(
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
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn)));
                      animationController?.forward();
                      return HotelListView(
                        callback: () {},
                        hotelData: hotelList[index],
                        animation: animation,
                        animationController: animationController!,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
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
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: btns(listData),
          ),
        );
      },
    );
  }
}

Widget btns(HomeList? listData) {
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
                BoxDecoration(color: Colors.grey.shade200.withOpacity(0.3)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  listData!.imagePath,
                  width: 80,
                  height: 80,
                  colorFilter: const ColorFilter.mode(
                      Color.fromARGB(255, 202, 97, 4), BlendMode.srcIn),
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
      WCustomDialog.show((cancelFunc) {
        return roomsWDG(cancelFunc);
      });
    },
  );
}

Widget roomsWDG(cancelFunc) {
  return Stateful(builder: (BuildContext context, StateSetter state, Map data) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg_floor.jpg'), fit: BoxFit.fill),
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(50),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NeumorphicButton(
                    padding: const EdgeInsets.all(4),
                    style: const NeumorphicStyle(
                      shadowLightColor: Color(0x8A000000),
                      shadowDarkColor: Color(0x8A000000),
                      boxShape: NeumorphicBoxShape.circle(),
                      shape: NeumorphicShape.flat,
                      depth: 10,
                      // intensity: 5,
                    ),
                    child: Container(
                      height: 70,
                      width: 70,
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          cancelFunc();
                        },
                        child: SvgPicture.asset(
                          "assets/ic_return.svg",
                          colorFilter:
                              ColorFilter.mode(Colors.black, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    onPressed: () {},
                  ),
                  Container(
                    width: w * 0.4,
                    height: h - 100,
                    margin: EdgeInsets.only(left: 70),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                          topRight: Radius.circular(8.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Color(0xFF3A5160).withOpacity(0.5),
                            offset: Offset(1.1, 1.1),
                            blurRadius: 20.0),
                      ],
                    ),
                    child: Neumorphic(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      style: NeumorphicStyle(
                        color: Colors.white,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12)),
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: NeumorphicButton(
                              // onPressed: _isButtonEnabled() ? () {} : null,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                          // _AvatarField(),
                          SizedBox(height: 8),
                          WTextField(
                            label: "First name",
                            hint: "",
                            onChanged: (firstName) {
                              state(() {
                                // this.firstName = firstName;
                              });
                            },
                          ),
                          SizedBox(height: 8),
                          WTextField(
                            label: "Last name",
                            hint: "",
                            onChanged: (lastName) {
                              state(() {
                                // this.lastName = lastName;
                              });
                            },
                          ),
                          SizedBox(height: 8),
                          // _AgeField(
                          //   age: this.age,
                          //   onChanged: (age) {
                          //     setState(() {
                          //       this.age = age;
                          //     });
                          //   },
                          // ),
                          SizedBox(height: 8),
                          // _GenderField(
                          //   gender: gender ?? Gender.NON_BINARY,
                          //   onChanged: (gender) {
                          //     setState(() {
                          //       this.gender = gender;
                          //     });
                          //   },
                          // ),
                          SizedBox(height: 8),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: w * 0.4,
                    height: h - 100,
                    margin: EdgeInsets.only(left: 70),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                          topRight: Radius.circular(8.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Color(0xFF3A5160).withOpacity(0.5),
                            offset: Offset(1.1, 1.1),
                            blurRadius: 20.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  });
}
