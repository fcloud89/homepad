import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class MyFloorPage extends StatefulWidget {
  const MyFloorPage({super.key});

  @override
  State<MyFloorPage> createState() => _MyFloorPageState();
}

class _MyFloorPageState extends State<MyFloorPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 50, right: 50, top: 72, bottom: 50),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg_floor.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Row(
        children: [],
      ),
    );
  }
}
