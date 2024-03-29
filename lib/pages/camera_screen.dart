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
import 'package:video_player/video_player.dart';

class MyCameraPage extends StatefulWidget {
  @override
  State<MyCameraPage> createState() => _MyCameraPageState();
}

class _MyCameraPageState extends State<MyCameraPage>
    with TickerProviderStateMixin {
  List infos = [];
  List<FileSystemEntity> fileList = [];
  Map currect = {};
  AnimationController? animationController;
  late VideoPlayerController controller;
  DBusClient dbClient = DBusClient.system();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    var file = File('assets/nb/camlist.json');
    file.readAsString().then((String contents) {
      infos = json.decode(contents) ?? [];
      if (infos.isNotEmpty) {
        currect = infos[0];
        controller = VideoPlayerController.networkUrl(Uri.parse(currect['url']))
          ..initialize().then((value) {
            controller.play().then((value) {
              print("****************************************************");
            });
            setState(() {});
          });
      }
      fileList = Directory('assets/nb').listSync();
      for (Map info in infos) {
        for (FileSystemEntity fileSystemEntity in fileList) {
          // String a = info['uid'].toRadixString(16);
          String uid = info['uid'].toString().padLeft(8, '0');

          if (fileSystemEntity.path.contains(uid)) {
            if (fileSystemEntity.path.endsWith("jpg") ||
                fileSystemEntity.path.endsWith("jpeg") ||
                fileSystemEntity.path.endsWith("png")) {
              info['pre'] = fileSystemEntity.path;
              print("$uid");
              print("$info");
            }
          }
        }
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.pause();
    controller.dispose();
    super.dispose();
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
            image: AssetImage('assets/imgs/bg_cover.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  child: Container(
                    color: Colors.black,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 60,
                                  height: 80,
                                  color: Colors.transparent,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: SvgPicture.asset(
                                    "assets/imgs/ic_return.svg",
                                    width: 30,
                                    height: 30,
                                    colorFilter: const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              "Live    ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  height: 1,
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              // image: DecorationImage(
                              //     image: AssetImage('assets/imgs/bg_vcr.jpg'),
                              //     fit: BoxFit.fill),
                            ),
                            child: controller.value.isInitialized
                                ? VideoPlayer(controller)
                                : SizedBox(),
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  currect.isEmpty ? '' : currect['loc'],
                                  style: TextStyle(
                                      fontSize: 32,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    margin: const EdgeInsets.only(right: 100),
                                    child: SvgPicture.asset(
                                      "assets/imgs/ic_fullscreen.svg",
                                      width: 50,
                                      height: 50,
                                      colorFilter: const ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: SvgPicture.asset(
                                      "assets/imgs/ic_info.svg",
                                      width: 56,
                                      height: 56,
                                      colorFilter: const ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
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
                          "assets/imgs/ic_signal_f.svg",
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
                          "assets/imgs/ic_battery.svg",
                          width: 50,
                          height: 50,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ],
                  ),
                  NeumorphicButton(
                    padding: EdgeInsets.zero,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(16),
                      ),
                      color: const Color(0xff2d2d2f),
                      shadowLightColor: Colors.transparent,
                      shape: NeumorphicShape.flat,
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "+",
                          style:
                              TextStyle(fontSize: 80, color: Color(0xffececec)),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (controller.value.isPlaying) {
                        controller.pause();
                      } else {
                        controller.play();
                      }
                    },
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
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
                              listData: infos[index],
                              callBack: () async {
                                currect = infos[index];
                                await controller.pause();
                                await controller.dispose();
                                controller = VideoPlayerController.networkUrl(
                                    Uri.parse(currect['url']))
                                  ..initialize().then((value) {
                                    controller.play();
                                    setState(() {});
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
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(16),
        ),
        color: Colors.black,
        shadowLightColor: Colors.transparent,
        shape: NeumorphicShape.flat,
      ),
      child: Container(
        decoration: BoxDecoration(
          image: listData['pre'] == null
              ? const DecorationImage(
                  image: AssetImage('assets/imgs/bg_vcr.jpg'), fit: BoxFit.fill)
              : DecorationImage(
                  image: FileImage(File(listData['pre'])), fit: BoxFit.fill),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              color: Colors.black.withOpacity(0.3),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(0xff2d2d2f),
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
                          color: Color(0xff2d2d2f),
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
                        color: Color(0xff2d2d2f),
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
      onPressed: () {
        callBack?.call();
      },
    );
  }
}
