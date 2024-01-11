import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:dbus/dbus.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepad/model/gdbus-nbware.dart';
import 'package:homepad/utils/SizeUtils.dart';
import 'package:homepad/utils/common_utils.dart';
import 'package:homepad/widgets/MTextField.dart';
import 'package:homepad/widgets/WLine.dart';
import 'package:homepad/widgets/WPopupWindow.dart';
import 'package:homepad/widgets/back_button.dart';
import 'package:homepad/widgets/custom_calendar.dart';
import 'package:homepad/widgets/fwidget/fRoundCheckBox.dart';
import 'package:homepad/widgets/fwidget/fradio.dart';
import 'package:homepad/widgets/video_popup_view.dart';
import 'package:table_calendar/table_calendar.dart';

class MyVcrPage extends StatefulWidget {
  @override
  State<MyVcrPage> createState() => _MyVcrPageState();
}

class _MyVcrPageState extends State<MyVcrPage> with TickerProviderStateMixin {
  List ritems = [];
  List infos = [];
  DateTime? minimumDate;
  DateTime? maximumDate;
  DateTime? initialStartDate;
  DateTime? initialEndDate;
  DateTime? startDate;
  DateTime? endDate;
  AnimationController? animationController;
  // late DBusClient dbClient;
  late ComSmarthomeNbwareGraph object;
  late StreamSubscription connectSS;
  late StreamSubscription recordSS;
  late StreamSubscription aiSS;
  List<FileSystemEntity> fileList = [];
  DateTime? _selectedDay;
  DateTime? _focusedDay;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // dbClient = DBusClient.session();
    // object = ComSmarthomeNbwareGraph(
    //     dbClient, 'com.smarthome.nbware', DBusObjectPath('/nbware/graph'));
    // connectSS = object.onConnectionNotify.asBroadcastStream().listen((event) {
    //   print(
    //       "onConnectionNotify  uid:${event.uid}  connection:${event.connection}");
    // });
    // recordSS = object.onRecordingNotify.asBroadcastStream().listen((event) {
    //   print(
    //       "onRecordingNotify  uid:${event.uid}  recording:${event.recording}");
    // });
    // aiSS = object.onAIDetectionNotify.asBroadcastStream().listen((event) {
    //   print(
    //       "onAIDetectionNotify  uid:${event.uid}  detection:${event.detection}");
    // });
    ritems.clear();
    var file = File('nb/camlist.json');
    file.readAsString().then((String contents) {
      ritems = json.decode(contents) ?? [];
      if (ritems.isNotEmpty) {
        var dir = Directory('nb/vcr');
        fileList = dir.listSync();
        infos.clear();
        String pathImg = "";
        for (FileSystemEntity fileSystemEntity in fileList) {
          String a = ritems[0]['uid'].toRadixString(16);
          String uid = a.padLeft(8, '0');
          if (fileSystemEntity.path.contains(uid)) {
            if (fileSystemEntity.path.endsWith("jpg") ||
                fileSystemEntity.path.endsWith("jpeg") ||
                fileSystemEntity.path.endsWith("png")) {
              pathImg = fileSystemEntity.path;
            }
            if (fileSystemEntity.path.endsWith("info")) {
              File i = File(fileSystemEntity.path);
              i.readAsString().then((String contents) {
                Map info = json.decode(contents) ?? {};
                info['img'] = pathImg;
                setState(() {
                  infos.add(info);
                });
              });
            }
          }
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          image: const DecorationImage(
            image: AssetImage('assets/bg_cover.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 210,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ListView(
                        padding: const EdgeInsets.only(left: 80),
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
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
                              callBack: () {
                                infos.clear();
                                String pathImg = "";
                                for (FileSystemEntity fileSystemEntity
                                    in fileList) {
                                  String a =
                                      ritems[index]['uid'].toRadixString(16);
                                  String uid = a.padLeft(8, '0');
                                  if (fileSystemEntity.path.contains(uid)) {
                                    if (fileSystemEntity.path.endsWith("jpg") ||
                                        fileSystemEntity.path
                                            .endsWith("jpeg") ||
                                        fileSystemEntity.path.endsWith("png")) {
                                      pathImg = fileSystemEntity.path;
                                    }
                                    if (fileSystemEntity.path
                                        .endsWith("info")) {
                                      File i = File(fileSystemEntity.path);
                                      i.readAsString().then((String contents) {
                                        Map info = json.decode(contents) ?? {};
                                        info['img'] = pathImg;
                                        print(info);
                                        setState(() {
                                          infos.add(info);
                                        });
                                      });
                                    }
                                  }
                                }
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                      IgnorePointer(
                          child: Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/bg_vcr_head.jpg'),
                                fit: BoxFit.fill)),
                      )),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'assets/bg_vcr_divide.jpg',
                          width: w,
                          fit: BoxFit.fill,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: 60,
                            height: 80,
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 20, top: 10),
                            child: SvgPicture.asset(
                              "assets/ic_return.svg",
                              width: 30,
                              height: 30,
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 18, right: 18, top: 12, bottom: 12),
                    child: GridView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 18,
                        crossAxisSpacing: 18,
                        childAspectRatio: 8 / 7,
                        crossAxisCount: 3,
                      ),
                      children: List<Widget>.generate(
                        infos.length,
                        (int index) {
                          final int count = infos.length;
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
                            listData: infos[index],
                            callBack: () {
                              for (FileSystemEntity fileSystemEntity
                                  in fileList) {
                                String a =
                                    ritems[index]['uid'].toRadixString(16);
                                String uid = a.padLeft(8, '0');
                                if (fileSystemEntity.path.endsWith("mp4") &&
                                    fileSystemEntity.path.contains(uid)) {
                                  print(
                                      "${ritems}  ${index}  ${uid}  ${fileSystemEntity.path}");
                                  // showDialog<dynamic>(
                                  //   context: context!,
                                  //   builder: (BuildContext context) =>
                                  //       VideoPopupView(
                                  //           url:
                                  //               // 'rtsp://admin:Admin123@172.17.33.24:80/ch0_0.264',
                                  //               // 'assets/video/test.mp4',
                                  //               fileSystemEntity.path),
                                  // );
                                }
                              }
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
          Container(
            width: w * 0.25,
            color: Colors.black,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Expanded(
                      child: Text(
                        "02:05  am",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 50,
                        height: 60,
                        margin: const EdgeInsets.only(right: 80),
                        alignment: Alignment.centerRight,
                        child: SvgPicture.asset(
                          "assets/ic_signal_f.svg",
                          width: 40,
                          height: 40,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 10),
                        alignment: Alignment.centerRight,
                        child: SvgPicture.asset(
                          "assets/ic_battery.svg",
                          width: 50,
                          height: 50,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  color: Colors.black,
                  height: w * 0.25,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TableCalendar(
                    shouldFillViewport: true,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: DateTime.now(),
                    daysOfWeekHeight: 30,
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      cellMargin: const EdgeInsets.all(10),
                      defaultTextStyle: const TextStyle(
                          color: Colors.white, fontSize: 24, height: 1),
                      weekendTextStyle: const TextStyle(
                          color: Colors.white, fontSize: 24, height: 1),
                      todayTextStyle: const TextStyle(
                          color: Colors.white, fontSize: 24, height: 1),
                      selectedTextStyle: const TextStyle(
                          color: Colors.black, fontSize: 24, height: 1),
                      defaultDecoration: BoxDecoration(
                        border: Border.all(width: 3, color: Colors.white),
                        shape: BoxShape.circle,
                      ),
                      weekendDecoration: BoxDecoration(
                        border: Border.all(width: 3, color: Colors.white),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                          color: Colors.white, fontSize: 24, height: 1),
                      weekendStyle: TextStyle(
                          color: Colors.white, fontSize: 24, height: 1),
                    ),
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      formatButtonTextStyle: const TextStyle(
                          color: Colors.white, fontSize: 30, height: 1),
                      titleTextStyle: const TextStyle(
                          color: Colors.white, fontSize: 30, height: 1),
                      leftChevronIcon: SvgPicture.asset(
                        "assets/ic_left.svg",
                        width: 30,
                        height: 30,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                      rightChevronIcon: SvgPicture.asset(
                        "assets/ic_right.svg",
                        width: 30,
                        height: 30,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (CalendarFormat) {},
                  ),
                ),
                Container(
                  height: 6,
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 8),
                  decoration: const BoxDecoration(
                      color: Color(0xff2d2d2f),
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tags:",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            getClips("entrance"),
                            getClips("entrance"),
                            getClips("entrance"),
                            getClips("entrance"),
                            getClips("entrance"),
                            getClips("entrance"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 6,
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xff2d2d2f),
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                ),
                Container(
                  height: 140,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 120,
                        child: Image.asset('assets/ic_man.png'),
                      ),
                      Container(
                        height: 90,
                        width: 120,
                        child: Image.asset('assets/ic_dog.png'),
                      ),
                      Container(
                        height: 90,
                        width: 140,
                        child: Image.asset('assets/ic_car.png'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget getClips(info) {
    return Container(
      child: Chip(
        label: Text(
          info,
          style: const TextStyle(color: Colors.white, fontSize: 24, height: 1),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        side: const BorderSide(width: 2, color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        color: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.blue;
          }
          return Colors.black;
        }),
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
  final bool checked = false;

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
      margin: const EdgeInsets.only(left: 12, top: 16, right: 12, bottom: 20),
      style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(12),
          ),
          color: Colors.white70,
          shape: NeumorphicShape.flat,
          shadowLightColor: Colors.transparent),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            image: listData['pre'] == null
                ? const DecorationImage(
                    image: AssetImage('assets/bg.jpg'), fit: BoxFit.fill)
                : DecorationImage(
                    image: FileImage(File(listData['pre'])), fit: BoxFit.fill),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 36,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  color: Colors.black.withOpacity(0.3),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: const Color(0xff2d2d2f),
                            border: Border.all(color: Colors.white),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: const Text(
                          "L1",
                          style: TextStyle(
                              fontSize: 16, color: Colors.white, height: 1),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: const Color(0xff2d2d2f),
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12))),
                          child: Text(
                            listData['loc'],
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white, height: 1),
                          ),
                        ),
                      ),
                      Container(
                        width: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: const Color(0xff2d2d2f),
                            border: Border.all(color: Colors.white),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: const Text(
                          "Cam01",
                          style: TextStyle(
                              fontSize: 16, color: Colors.white, height: 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(10),
                  child: fRoundCheckBox(
                    checkedColor: const Color(0xffeb4e3d),
                    uncheckedColor: Colors.transparent,
                    border: Border.all(color: Colors.white, width: 2),
                    onTap: (check) {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onPressed: () {
        callBack?.call();
      },
    );
  }
}

class VcrListView extends StatelessWidget {
  const VcrListView({
    Key? key,
    this.listData,
    this.callBack,
    this.animationController,
    this.animation,
  }) : super(key: key);

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
            child: btns(bct),
          ),
        );
      },
    );
  }

  Widget btns(BuildContext bct) {
    return NeumorphicButton(
      padding: EdgeInsets.zero,
      style: NeumorphicStyle(
        color: Colors.transparent,
        shape: NeumorphicShape.flat,
        shadowLightColor: Colors.transparent,
        boxShape: NeumorphicBoxShape.roundRect(
            const BorderRadius.all(Radius.circular(16))),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 9,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: listData['img'] == null
                  ? Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/bg_vcr.jpg'),
                            fit: BoxFit.cover),
                      ),
                      child: const Text(
                        "No Preview",
                        style: TextStyle(color: Colors.white, fontSize: 32),
                      ),
                    )
                  : Image.file(
                      File(listData['img']),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Backyard',
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.6,
                      fontSize: 32,
                    ),
                  ),
                  Text(
                    '18:34 5min',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Human·Vehcle',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 24,
                        height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      onPressed: () {
        callBack?.call();
      },
    );
  }
}
