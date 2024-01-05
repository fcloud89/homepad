import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:dbus/dbus.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepad/model/gdbus-nbware.dart';
import 'package:homepad/utils/SizeUtils.dart';
import 'package:homepad/widgets/MTextField.dart';
import 'package:homepad/widgets/WLine.dart';
import 'package:homepad/widgets/WPopupWindow.dart';
import 'package:homepad/widgets/back_button.dart';
import 'package:homepad/widgets/custom_calendar.dart';
import 'package:homepad/widgets/video_popup_view.dart';

class MyVcrPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(39, 72, 98, 1),
      body: _MyVcrPage(),
    );
  }
}

class _MyVcrPage extends StatefulWidget {
  @override
  State<_MyVcrPage> createState() => _MyVcrPageState();
}

class _MyVcrPageState extends State<_MyVcrPage> with TickerProviderStateMixin {
  final ritems = List<String>.generate(4, (i) => 'area ${i + 1}');
  final items = List<String>.generate(20, (i) => 'camera ${i + 1}');
  List testList = ["Camera 1", "Camera 2", "Camera 3", "Camera 4", "Camera 5"];
  List cameraList = [
    "camera 1",
    "camera 2",
    "camera 3",
    "camera 4",
    "camera 5"
  ];
  DateTime? minimumDate;
  DateTime? maximumDate;
  DateTime? initialStartDate;
  DateTime? initialEndDate;
  DateTime? startDate;
  DateTime? endDate;
  AnimationController? animationController;
  late DBusClient dbClient;
  late ComSmarthomeNbwareGraph object;
  late StreamSubscription connectSS;
  late StreamSubscription recordSS;
  late StreamSubscription aiSS;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    dbClient = DBusClient.session();
    object = ComSmarthomeNbwareGraph(
        dbClient, 'com.smarthome.nbware', DBusObjectPath('/nbware/graph'));
    connectSS = object.onConnectionNotify.asBroadcastStream().listen((event) {
      print(
          "onConnectionNotify  uid:${event.uid}  connection:${event.connection}");
    });
    recordSS = object.onRecordingNotify.asBroadcastStream().listen((event) {
      print(
          "onRecordingNotify  uid:${event.uid}  recording:${event.recording}");
    });
    aiSS = object.onAIDetectionNotify.asBroadcastStream().listen((event) {
      print(
          "onAIDetectionNotify  uid:${event.uid}  detection:${event.detection}");
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Row(children: [
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
                    "vcr list",
                    style: TextStyle(color: Colors.white70, fontSize: 30),
                  ),
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 150,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: GridView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 0.0,
                        crossAxisSpacing: 0.0,
                        childAspectRatio: 9 / 16,
                      ),
                      children: List<Widget>.generate(
                        ritems.length,
                        (int index) {
                          final int count = ritems.length;
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
                            listData: ritems[index],
                            callBack: () {},
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 5,
              color: Colors.white,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5),
                child: GridView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisSpacing: 0.0,
                    crossAxisSpacing: 0.0,
                    childAspectRatio: 16 / 9,
                    maxCrossAxisExtent: 360,
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
                      return VcrListView(
                        animation: animation,
                        animationController: animationController,
                        listData: items[index],
                        callBack: () {
                          showDialog<dynamic>(
                            context: context!,
                            builder: (BuildContext context) => VideoPopupView(
                              url:
                                  // 'rtsp://admin:Admin123@172.17.33.24:80/ch0_0.264',
                                  'assets/video/test.mp4',
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Container(
      //   width: 1,
      //   color: Colors.white70,
      // ),
      Container(
        width: w * 0.25,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Container(
              color: Colors.white70,
              child: CustomCalendarView(
                minimumDate: minimumDate,
                maximumDate: maximumDate,
                initialEndDate: initialEndDate,
                initialStartDate: initialStartDate,
                startEndDateChange:
                    (DateTime startDateData, DateTime endDateData) {
                  setState(() {
                    startDate = startDateData;
                    endDate = endDateData;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white70,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(children: [
                  const Text(
                    "vcr info",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    ]);
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
                              fontSize: 20.px, color: Color(0xff333333)),
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

  @override
  void dispose() {
    super.dispose();
    connectSS.cancel();
    recordSS.cancel();
    aiSS.cancel();
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
      margin: EdgeInsets.all(10),
      style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(12),
          ),
          color: Colors.white70,
          shape: NeumorphicShape.flat,
          shadowLightColor: Colors.transparent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/ic_room.svg",
            width: 60,
            height: 60,
            colorFilter: const ColorFilter.mode(
                Color.fromARGB(255, 202, 97, 4), BlendMode.srcIn),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
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

class VcrListView extends StatelessWidget {
  const VcrListView(
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
      margin: EdgeInsets.all(10),
      style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(12),
          ),
          color: Colors.white70,
          shape: NeumorphicShape.flat,
          shadowLightColor: Colors.transparent),
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
            margin: const EdgeInsets.only(left: 10, right: 10),
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
