import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:homepad/model/msg_list_data.dart';
import 'package:homepad/pages/hotel_list_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController? animationController;
  List<HotelListData> hotelList = HotelListData.hotelList;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 50, right: 50, top: 72, bottom: 50),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
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
                const Expanded(child: SizedBox()),
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.grey.shade200.withOpacity(0.3)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.046),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.012),
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 1.93,
                          width: MediaQuery.of(context).size.width / 3.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.shade200.withOpacity(0.3)),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                    Expanded(
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 5.2,
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
                  height: MediaQuery.of(context).size.height / 3,
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
