import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'navigation_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        platform: TargetPlatform.iOS,
      ),
      home: ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => Container(color: Colors.amber),
          landscape: (context) => Container(color: Colors.blueAccent),
        ),
        tablet: OrientationLayoutBuilder(
          portrait: (context) => Container(color: Colors.green),
          landscape: (context) => Container(color: Colors.pink),
        ),
        desktop: OrientationLayoutBuilder(
          portrait: (context) => Container(color: Colors.deepPurpleAccent),
          landscape: (context) => NavigationHomeScreen(),
        ),
      ),
    );
  }
}
