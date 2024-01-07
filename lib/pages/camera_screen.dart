import 'dart:convert';
import 'dart:developer';
import 'dart:io';
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

class MyCameraPage extends StatefulWidget {
  @override
  State<MyCameraPage> createState() => _MyCameraPageState();
}

class _MyCameraPageState extends State<MyCameraPage>
    with TickerProviderStateMixin {
  List infos = [];
  Map currect = {};
  AnimationController? animationController;
  DBusClient dbClient = DBusClient.system();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    var file = File('nb/camlist.json');
    file.readAsString().then((String contents) {
      setState(() {
        infos = json.decode(contents) ?? [];
        if (infos.isNotEmpty) {
          currect = infos[0];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          image: DecorationImage(
            image: AssetImage('assets/bg_cover.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 70,
              color: Colors.black,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "02:05  am",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Container(
                    width: w * 0.15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            "assets/ic_signal_f.svg",
                            width: 30,
                            height: 30,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          ),
                        ),
                        Container(
                          width: 64,
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            "assets/ic_battery.svg",
                            width: 40,
                            height: 40,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Color(0xff3f3f3f),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: SvgPicture.asset(
                                  "assets/ic_return.svg",
                                  width: 30,
                                  height: 30,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Text(
                                        'Position.Layer.Name',
                                        style: TextStyle(
                                            fontSize: 24, color: Colors.white),
                                      ),
                                    )),
                                    GestureDetector(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: SvgPicture.asset(
                                          "assets/ic_info.svg",
                                          width: 40,
                                          height: 40,
                                          colorFilter: const ColorFilter.mode(
                                              Colors.white, BlendMode.srcIn),
                                        ),
                                      ),
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(left: 20),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Container(
                                    color: Colors.black,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Live Video",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 60,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: w * 0.15,
                    color: Colors.black,
                    margin: EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        NeumorphicButton(
                          padding: EdgeInsets.zero,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          style: NeumorphicStyle(
                            boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(8),
                            ),
                            color: Color(0xff1c1c1e),
                            shadowLightColor: Colors.transparent,
                            shape: NeumorphicShape.flat,
                          ),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Add new camera",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          onPressed: () {},
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 0),
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
                                infos.length,
                                (int index) {
                                  final int count = infos.length;
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
                                  return HomeListView(
                                    animation: animation,
                                    animationController: animationController,
                                    listData: infos[index],
                                    callBack: () {
                                      setState(() {
                                        currect = infos[index];
                                      });
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
                ],
              ),
            )
          ],
        ),
      ),
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
              listData['loc'],
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
