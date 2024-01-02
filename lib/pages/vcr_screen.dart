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
    return NeumorphicTheme(
      theme: const NeumorphicThemeData(
        baseColor: Color.fromARGB(255, 232, 232, 232),
        defaultTextColor: Color(0xFF3E3E3E),
        accentColor: Colors.grey,
        variantColor: Colors.black38,
        depth: 8,
        intensity: 0.65,
      ),
      themeMode: ThemeMode.light,
      child: Material(
        child: NeumorphicBackground(
            child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg_room.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: _MyVcrPage(),
        )),
      ),
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
    return Container(
      height: h,
      width: w,
      padding: const EdgeInsets.only(left: 50, right: 50, top: 50, bottom: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 70,
            height: 70,
            child: NeumorphicBack(),
          ),
          Container(
            width: w * 0.6,
            height: h,
            margin: const EdgeInsets.symmetric(horizontal: 50),
            child: ClipRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.black87.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        const Text(
                          "vcr list",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 25),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "areas",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
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
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(
                                        CurvedAnimation(
                                          parent: animationController!,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        ),
                                      );
                                      animationController?.forward();
                                      return HomeListView(
                                        animation: animation,
                                        animationController:
                                            animationController,
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
                        Neumorphic(
                          child: Container(
                            height: 5,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 25),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "vcrs",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: GridView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                mainAxisSpacing: 0.0,
                                crossAxisSpacing: 0.0,
                                childAspectRatio: 16 / 9,
                                maxCrossAxisExtent: 480,
                              ),
                              children: List<Widget>.generate(
                                items.length,
                                (int index) {
                                  final int count = items.length;
                                  final Animation<double> animation =
                                      Tween<double>(begin: 0.0, end: 1.0)
                                          .animate(
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
                                        builder: (BuildContext context) =>
                                            VideoPopupView(
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
                  )),
            ),
          ),
          Expanded(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "vcr info",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 24),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: NeumorphicButton(
                              padding: EdgeInsets.zero,
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    const BorderRadius.all(
                                        Radius.circular(12))),
                              ),
                              child: Container(
                                width: 100,
                                height: 48,
                                alignment: Alignment.center,
                                child: const Text(
                                  "refresh",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                              onPressed: () {
                                object.callGetAllStates().then((value) {
                                  print("${value.length}");
                                  print("${value[0][0]}");
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Neumorphic(
                          child: Container(
                        color: Colors.white,
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
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Neumorphic(
                          child: Container(
                            color: Colors.white,
                            alignment: Alignment.center,
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
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
      // padding: EdgeInsets.zero,
      margin: EdgeInsets.all(20),
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(12),
        ),
        color: Colors.white,
        shape: NeumorphicShape.flat,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/ic_room.svg",
            width: 40,
            height: 40,
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
      // padding: EdgeInsets.zero,
      margin: EdgeInsets.all(20),
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(12),
        ),
        color: Colors.white,
        shape: NeumorphicShape.flat,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/ic_camera.svg",
            width: 40,
            height: 40,
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
