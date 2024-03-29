import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:homepad/db/DatabaseHelper.dart';
import 'package:homepad/pages/home_screen.dart';
import 'package:homepad/utils/AppLocale.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primaryColor: const Color(0xFF2E4861),
        primaryColorDark: const Color(0xFF1C2B3C),
        scaffoldBackgroundColor: const Color(0xffffffff),
        platform: TargetPlatform.iOS,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // DatabaseHelper _databaseHelper = DatabaseHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayoutBuilder(
        portrait: (context) => Container(color: Colors.blueAccent),
        landscape: (context) => const MyHomePage(),
      ),
      tablet: OrientationLayoutBuilder(
        portrait: (context) => Container(color: Colors.green),
        landscape: (context) => Container(color: Colors.pink),
      ),
      desktop: OrientationLayoutBuilder(
        portrait: (context) => Container(color: Colors.deepPurpleAccent),
        landscape: (context) => const MyHomePage(),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('state = $state');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
