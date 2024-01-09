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
import 'package:homepad/widgets/video_popup_view.dart';

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
                  height: 200,
                  child: Stack(
                    children: [
                      ListView(
                        padding: EdgeInsets.only(left: 80),
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
                      Image.asset('assets/bg_vcr_head.jpg'),
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
                    padding: const EdgeInsets.all(5),
                    child: GridView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisSpacing: 0.0,
                        crossAxisSpacing: 0.0,
                        childAspectRatio: 21 / 9,
                        maxCrossAxisExtent: 540,
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
                                  showDialog<dynamic>(
                                    context: context!,
                                    builder: (BuildContext context) =>
                                        VideoPopupView(
                                            url:
                                                // 'rtsp://admin:Admin123@172.17.33.24:80/ch0_0.264',
                                                // 'assets/video/test.mp4',
                                                fileSystemEntity.path),
                                  );
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
            width: w * 0.18,
            color: Colors.black,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Text(
                        "02:05  am",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 60,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        "assets/ic_signal_f.svg",
                        width: 40,
                        height: 40,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                    Container(
                      width: 80,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        "assets/ic_battery.svg",
                        width: 50,
                        height: 50,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ],
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
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: const Column(children: [
                      Text(
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
        ]),
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
      margin: const EdgeInsets.all(16),
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
                    image: AssetImage('assets/bg_vcr.jpg'), fit: BoxFit.fill)
                : DecorationImage(
                    image: FileImage(File(listData['pre'])), fit: BoxFit.fill),
          ),
          child: Align(
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
                )),
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
      margin: const EdgeInsets.all(10),
      style: const NeumorphicStyle(
          color: Colors.transparent,
          shape: NeumorphicShape.flat,
          shadowLightColor: Colors.transparent),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
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
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.3),
                  ),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    '${listData['uid']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                    ),
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
