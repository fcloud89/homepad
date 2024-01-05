import 'dart:developer';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:dbus/dbus.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepad/utils/SizeUtils.dart';
import 'package:homepad/widgets/MTextField.dart';
import 'package:homepad/widgets/WLine.dart';
import 'package:homepad/widgets/WPopupWindow.dart';
import 'package:homepad/widgets/back_button.dart';

class MyCameraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _MyCameraPage(),
    );
  }
}

class _MyCameraPage extends StatefulWidget {
  @override
  State<_MyCameraPage> createState() => _MyCameraPageState();
}

class _MyCameraPageState extends State<_MyCameraPage>
    with TickerProviderStateMixin {
  final items = List<String>.generate(20, (i) => 'camera ${i + 1}');
  List testList = ["area 1", "area 2", "area 3", "area 4", "area 5"];
  List cameraList = [
    "camera 1",
    "camera 2",
    "camera 3",
    "camera 4",
    "camera 5"
  ];
  AnimationController? animationController;
  DBusClient dbClient = DBusClient.system();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                height: 70,
                color: const Color.fromRGBO(23, 44, 60, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white70,
                          size: 44,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Text(
                      "camera #2345",
                      style: TextStyle(color: Colors.white70, fontSize: 30),
                    ),
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: SvgPicture.asset(
                          "assets/ic_info.svg",
                          width: 40,
                          height: 40,
                          colorFilter: const ColorFilter.mode(
                              Colors.white70, BlendMode.srcIn),
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: const Text(
                        "TV",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),

                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     // Stack(
                  //     //   alignment: Alignment.center,
                  //     //   children: [
                  //     //     Align(
                  //     //       alignment: Alignment.centerLeft,
                  //     //       child: NeumorphicButton(
                  //     //         padding: EdgeInsets.zero,
                  //     //         style: NeumorphicStyle(
                  //     //           color: const Color.fromARGB(255, 202, 97, 4),
                  //     //           shape: NeumorphicShape.flat,
                  //     //           boxShape: NeumorphicBoxShape.roundRect(
                  //     //               const BorderRadius.all(
                  //     //                   Radius.circular(12))),
                  //     //         ),
                  //     //         child: Container(
                  //     //           width: 48,
                  //     //           height: 48,
                  //     //           alignment: Alignment.center,
                  //     //           child: SvgPicture.asset(
                  //     //             "assets/ic_del.svg",
                  //     //             width: 32,
                  //     //             height: 32,
                  //     //             colorFilter: const ColorFilter.mode(
                  //     //                 Colors.white, BlendMode.srcIn),
                  //     //           ),
                  //     //         ),
                  //     //         onPressed: () async {
                  //     //           // DBusRemoteObject dBusRemoteObject =
                  //     //           //     DBusRemoteObject(dbClient,
                  //     //           //         name: 'org.freedesktop.NetworkManager',
                  //     //           //         path: DBusObjectPath(
                  //     //           //             '/org/freedesktop/NetworkManager'));

                  //     //           // await dBusRemoteObject.setProperty(
                  //     //           //     'org.freedesktop.NetworkManager',
                  //     //           //     'WirelessEnabled',
                  //     //           //     const DBusBoolean(true));

                  //     //           // DBusValue devices =
                  //     //           //     await dBusRemoteObject.getProperty(
                  //     //           //         'org.freedesktop.NetworkManager',
                  //     //           //         'Devices');
                  //     //           // Iterator<String> it =
                  //     //           //     devices.asStringArray().iterator;
                  //     //           // while (it.moveNext()) {
                  //     //           //   print("${it.current}");
                  //     //           // }
                  //     //         },
                  //     //       ),
                  //     //     ),
                  //     //   ],
                  //     // ),
                  //     // Row(
                  //     //   children: [
                  //     //     Padding(
                  //     //       padding: const EdgeInsets.symmetric(
                  //     //           horizontal: 20.0, vertical: 12),
                  //     //       child: Text(
                  //     //         "choose area",
                  //     //         style: TextStyle(
                  //     //           fontWeight: FontWeight.w700,
                  //     //           color:
                  //     //               NeumorphicTheme.defaultTextColor(context),
                  //     //           fontSize: 20,
                  //     //         ),
                  //     //       ),
                  //     //     ),
                  //     //     Container(
                  //     //       width: w * 0.22,
                  //     //       child: Builder(builder: (BuildContext popCT) {
                  //     //         return NeumorphicButton(
                  //     //           padding: EdgeInsets.zero,
                  //     //           margin: const EdgeInsets.only(right: 10),
                  //     //           style: NeumorphicStyle(
                  //     //             shape: NeumorphicShape.flat,
                  //     //             boxShape: NeumorphicBoxShape.roundRect(
                  //     //                 const BorderRadius.all(
                  //     //                     Radius.circular(12))),
                  //     //           ),
                  //     //           child: Stack(
                  //     //             alignment: Alignment.centerRight,
                  //     //             children: [
                  //     //               Container(
                  //     //                 height: 48,
                  //     //                 padding: const EdgeInsets.symmetric(
                  //     //                     horizontal: 20),
                  //     //                 alignment: Alignment.centerLeft,
                  //     //                 child: const Text(
                  //     //                   "Area #1",
                  //     //                   style: TextStyle(
                  //     //                       color: Colors.grey, fontSize: 20),
                  //     //                 ),
                  //     //               ),
                  //     //               SvgPicture.asset(
                  //     //                 "assets/ic_arrow_down.svg",
                  //     //                 width: 40,
                  //     //                 height: 40,
                  //     //                 colorFilter: const ColorFilter.mode(
                  //     //                     Color.fromARGB(255, 202, 97, 4),
                  //     //                     BlendMode.srcIn),
                  //     //               ),
                  //     //             ],
                  //     //           ),
                  //     //           onPressed: () {
                  //     //             WPopupWindow.show(
                  //     //               getListWidget(testList),
                  //     //               radius: 12,
                  //     //               targetContext: popCT,
                  //     //               width: w * 0.215,
                  //     //               height: 200.px,
                  //     //               preferDirection: PreferDirection.bottomLeft,
                  //     //               verticalOffset: 1.px,
                  //     //             );
                  //     //           },
                  //     //         );
                  //     //       }),
                  //     //     ),
                  //     //     Expanded(
                  //     //       child: MTextField(
                  //     //         label: "camera name",
                  //     //         directionCol: false,
                  //     //         onChanged: (firstName) {
                  //     //           log(firstName);
                  //     //           // setState(() {});
                  //     //         },
                  //     //       ),
                  //     //     ),
                  //     //   ],
                  //     // ),
                  //     // const SizedBox(height: 10),
                  //     // MTextField(
                  //     //   label: "camera description",
                  //     //   directionCol: false,
                  //     //   onChanged: (lastName) {
                  //     //     // setState(() {});
                  //     //   },
                  //     // ),
                  //   ],
                  // ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: w * 0.15,
          color: Color.fromRGBO(39, 72, 98, 1),
          child: Column(
            children: [
              Container(
                height: 70,
                color: const Color.fromRGBO(23, 44, 60, 1),
                alignment: Alignment.center,
                child: const Text(
                  "camera list",
                  style: TextStyle(color: Colors.white70, fontSize: 24),
                ),
              ),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: GridView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 0.0,
                      crossAxisSpacing: 0.0,
                      childAspectRatio: 16 / 9,
                    ),
                    children: List<Widget>.generate(
                      items.length,
                      (int index) {
                        final int count = items.length;
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
                          listData: items[index],
                          callBack: () {},
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getListWidget(list) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Scrollbar(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: [
                Material(
                  child: Ink(
                    child: InkWell(
                      onTap: () async {
                        BotToast.removeAll(BotToast.attachedKey);
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 60.px,
                        child: Text(
                          list[index],
                          style: TextStyle(
                              fontSize: 20.px, color: const Color(0xff333333)),
                        ),
                      ),
                    ),
                  ),
                ),
                WLine(
                  marginLeft: 20.px,
                  marginRight: 20.px,
                ),
              ],
            );
          },
          itemCount: list.length,
        ),
      ),
    );
  }

  Widget getCameraListWidget(list) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Scrollbar(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: [
                Material(
                  child: Ink(
                    child: InkWell(
                      onTap: () async {
                        BotToast.removeAll(BotToast.attachedKey);
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 60.px,
                        child: Text(
                          list[index],
                          style: TextStyle(
                              fontSize: 20.px, color: const Color(0xff333333)),
                        ),
                      ),
                    ),
                  ),
                ),
                WLine(
                  marginLeft: 20.px,
                  marginRight: 20.px,
                ),
              ],
            );
          },
          itemCount: list.length,
        ),
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

  final dynamic? listData;
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

  Widget btns(BuildContext bct, dynamic? listData) {
    return NeumorphicButton(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(8),
        ),
        color: Colors.white70,
        shadowLightColor: Colors.transparent,
        shape: NeumorphicShape.flat,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/ic_camera.svg",
            width: 60,
            height: 60,
            colorFilter: const ColorFilter.mode(
                Color.fromARGB(255, 202, 97, 4), BlendMode.srcIn),
          ),
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: Text(
              listData,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 28,
              ),
            ),
          )
        ],
      ),
      onPressed: () {
        callBack?.call();
      },
    );
  }
}
