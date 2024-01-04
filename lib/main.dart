import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:homepad/pages/home_screen.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
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
        primaryColor: const Color(0xFF2E4861),
        primaryColorDark: const Color(0xFF1C2B3C),
        scaffoldBackgroundColor: const Color(0xffffffff),
        platform: TargetPlatform.iOS,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
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
          landscape: (context) => const MyHomePage(),
        ),
      ),
    );
  }
}
