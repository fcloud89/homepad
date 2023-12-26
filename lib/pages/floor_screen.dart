import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepad/widgets/MTextField.dart';
import 'package:homepad/widgets/back_button.dart';

class MyFloorPage extends StatelessWidget {
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
              image: AssetImage('assets/bg_floor.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: const _MyFloorPage(),
        )),
      ),
    );
  }
}

class _MyFloorPage extends StatefulWidget {
  const _MyFloorPage();

  @override
  State<_MyFloorPage> createState() => _MyFloorPageState();
}

class _MyFloorPageState extends State<_MyFloorPage> {
  final items = List<String>.generate(20, (i) => 'Item ${i + 1}');

  @override
  void initState() {
    super.initState();
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
                          "Floor list",
                          style: TextStyle(color: Colors.black87, fontSize: 24),
                        ),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: ListView.builder(
                            itemCount: 50,
                            itemBuilder: (BuildContext context, int index) {
                              return buildItem(index);
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
                      color: Colors.black87.withOpacity(0.1),
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
                              "Floor info",
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
                      MTextField(
                        label: "Floor name",
                        hint: "",
                        onChanged: (firstName) {
                          log(firstName);
                          // setState(() {});
                        },
                      ),
                      MTextField(
                        label: "Floor description",
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

  Widget buildItem(int index) {
    return Slidable(
      key: const ValueKey(0),
      // startActionPane: ActionPane(
      //   motion: const ScrollMotion(),
      //   // dismissible: DismissiblePane(onDismissed: () {}),
      //   children: [
      //     SlidableAction(
      //       onPressed: (BuildContext context) {},
      //       backgroundColor: const Color(0xFFFE4A49),
      //       foregroundColor: Colors.white,
      //       icon: Icons.delete,
      //       label: 'Delete',
      //     ),
      //     SlidableAction(
      //       onPressed: (BuildContext context) {},
      //       backgroundColor: const Color(0xFF21B7CA),
      //       foregroundColor: Colors.white,
      //       icon: Icons.share,
      //       label: 'Share',
      //     ),
      //   ],
      // ),
      // endActionPane: ActionPane(
      //   motion: const ScrollMotion(),
      //   children: [
      //     SlidableAction(
      //       // An action can be bigger than the others.
      //       flex: 2,
      //       onPressed: (BuildContext context) {},
      //       backgroundColor: const Color(0xFF7BC043),
      //       foregroundColor: Colors.white,
      //       icon: Icons.archive,
      //       label: 'Archive',
      //     ),
      //     SlidableAction(
      //       onPressed: (BuildContext context) {},
      //       backgroundColor: const Color(0xFF0392CF),
      //       foregroundColor: Colors.white,
      //       icon: Icons.save,
      //       label: 'Save',
      //     ),
      //   ],
      // ),
      child: buildContainer(index),
    );
  }

  Widget buildContainer(index) {
    return GestureDetector(
      onTap: () {
        print("$index");
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
