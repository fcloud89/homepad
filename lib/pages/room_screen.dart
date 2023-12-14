import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class MyRoomPage extends StatefulWidget {
  const MyRoomPage({super.key});

  @override
  State<MyRoomPage> createState() => _MyRoomPageState();
}

class _MyRoomPageState extends State<MyRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 50, right: 50, top: 72, bottom: 50),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg_room.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Row(
        children: [],
      ),
    );
  }
}
