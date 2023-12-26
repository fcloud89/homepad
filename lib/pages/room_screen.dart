import 'dart:developer';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepad/utils/SizeUtils.dart';
import 'package:homepad/widgets/MTextField.dart';
import 'package:homepad/widgets/WLine.dart';
import 'package:homepad/widgets/WPopupWindow.dart';
import 'package:homepad/widgets/back_button.dart';

class MyRoomPage extends StatelessWidget {
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
          child: const _MyRoomPage(),
        )),
      ),
    );
  }
}

class _MyRoomPage extends StatefulWidget {
  const _MyRoomPage();

  @override
  State<_MyRoomPage> createState() => _MyRoomPageState();
}

class _MyRoomPageState extends State<_MyRoomPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  final items = List<String>.generate(20, (i) => 'Item ${i + 1}');
  List testList = ["floor 1", "floor 2", "floor 3", "floor 4", "floor 5"];

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
            width: w * 0.5,
            height: h,
            margin: const EdgeInsets.symmetric(horizontal: 50),
            child: ClipRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.black87.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        const Text(
                          "Room list",
                          style: TextStyle(color: Colors.black87, fontSize: 24),
                        ),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: ListView.builder(
                            itemCount: items.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              final int count = items.length;
                              final Animation<double> animation =
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                      CurvedAnimation(
                                          parent: animationController!,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn)));
                              animationController?.forward();
                              return RoomListView(
                                animation: animation,
                                animationController: animationController!,
                                callBack: () {},
                                listData: items[index],
                              );
                            },
                          ),
                        )),
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
                              "Room info",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 24),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: NeumorphicButton(
                              padding: EdgeInsets.zero,
                              style: NeumorphicStyle(
                                color: Color.fromARGB(255, 202, 97, 4),
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    const BorderRadius.all(
                                        Radius.circular(12))),
                              ),
                              child: Container(
                                width: 48,
                                height: 48,
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  "assets/ic_del.svg",
                                  width: 32,
                                  height: 32,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                ),
                              ),
                              onPressed: () {},
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
                                  "save",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 12),
                            child: Text(
                              "choose floor",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color:
                                    NeumorphicTheme.defaultTextColor(context),
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Builder(builder: (BuildContext popCT) {
                              return NeumorphicButton(
                                padding: EdgeInsets.zero,
                                margin: EdgeInsets.only(right: 10),
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      const BorderRadius.all(
                                          Radius.circular(12))),
                                ),
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    Container(
                                      height: 48,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        "Build No.1 Floor 1#",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 20),
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      "assets/ic_arrow_down.svg",
                                      width: 40,
                                      height: 40,
                                      colorFilter: const ColorFilter.mode(
                                          Color.fromARGB(255, 202, 97, 4),
                                          BlendMode.srcIn),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  WPopupWindow.show(
                                    getListWidget(testList),
                                    targetContext: popCT,
                                    width: w * 0.245,
                                    height: 200.px,
                                    preferDirection: PreferDirection.bottomLeft,
                                    verticalOffset: 1.px,
                                  );
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      MTextField(
                        label: "Room name",
                        hint: "",
                        onChanged: (firstName) {
                          log(firstName);
                          // setState(() {});
                        },
                      ),
                      MTextField(
                        label: "Room description",
                        hint: "",
                        onChanged: (lastName) {
                          // setState(() {});
                        },
                      ),
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

  Widget getListWidget(list) {
    return Scrollbar(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              Material(
                color: Colors.white,
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
    );
  }
}

class RoomListView extends StatelessWidget {
  const RoomListView(
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
    return GestureDetector(
      onTap: () {
        callBack?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/ic_floor.svg",
              width: 40,
              height: 40,
              colorFilter: const ColorFilter.mode(
                  Color.fromARGB(255, 202, 97, 4), BlendMode.srcIn),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "早起的年轻人",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500, height: 2),
                  ),
                  Text(
                    "一个爱写代码 的程序员 也会早起那么一点点",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
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
}
