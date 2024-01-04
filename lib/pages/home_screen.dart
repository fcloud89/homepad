import 'dart:async';
import 'dart:ui';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepad/http/HttpUtils.dart';
import 'package:homepad/model/homelist.dart';
import 'package:homepad/model/msg_list_data.dart';
import 'package:homepad/pages/area_screen.dart';
import 'package:homepad/pages/camera_screen.dart';
import 'package:homepad/pages/scene_screen.dart';
import 'package:homepad/pages/vcr_screen.dart';
import 'package:homepad/utils/Constant.dart';
import 'package:homepad/utils/RouteHelper.dart';
import 'package:homepad/widgets/digital_clock/slide_digital_clock.dart';
import 'package:homepad/widgets/panel.dart';
import 'package:weather/weather.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController? animationController;
  List<HotelListData> hotelList = HotelListData.hotelList;
  List<HomeList> homeList = HomeList.homeList;
  Weather? weather;
  List<Weather> weathers = [];
  late WeatherFactory wf;
  late Timer weatherTimer;
  final PanelController _panelController = PanelController();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    wf = WeatherFactory(Constant.weatherApiKey);
    updateWeather();
    weatherTimer = Timer.periodic(const Duration(minutes: 60), (timer) {
      updateWeather();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF1C2B3C),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/th.webp"))),
        child: SlidingUpPanel(
          controller: _panelController,
          slideDirection: SlideDirection.DOWN,
          color: Colors.transparent,
          boxShadow: [],
          minHeight: 50,
          maxHeight: 700,
          header: Container(
              height: 50,
              width: w,
              color: Colors.transparent,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  if (_panelController.isPanelOpen) {
                    _panelController.close();
                  } else if (_panelController.isPanelClosed) {
                    _panelController.open();
                  }
                },
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New!!!   ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(18))),
                        child: Text(
                          "3",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              )),
          // footer: Container(
          //   height: 50,
          //   width: w,
          //   color: Colors.amber,
          // ),
          panel: Container(
            alignment: Alignment.topCenter,
            child: Container(
              width: 800,
              height: 650,
              color: Colors.white,
              child: Text("This is the sliding Widget"),
            ),
          ),
          body: Column(
            children: [
              const Expanded(child: SizedBox()),
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 50),
                          child: weather == null
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Text(
                                      "${weather?.temperature?.celsius?.round()}℃",
                                      style: const TextStyle(
                                          fontSize: 160, color: Colors.white),
                                    ),
                                    // Text(
                                    //   "${weather?.tempMin?.celsius?.round()}℃ ~ ${weather?.tempMax?.celsius?.round()}℃",
                                    //   style: const TextStyle(
                                    //       fontSize: 60, color: Colors.white),
                                    // ),
                                    Row(
                                      children: [
                                        Image.network(
                                            "https://openweathermap.org/themes/openweathermap/assets/vendor/owm/img/widgets/${weather?.weatherIcon}.png"),
                                        Text(
                                          "${weather?.weatherMain}",
                                          style: const TextStyle(
                                              fontSize: 60,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                        Container(
                          width: w / 2,
                          child: DigitalClock(
                            digitAnimationStyle: Curves.elasticOut,
                            is24HourTimeFormat: false,
                            areaAligment: AlignmentDirectional.center,
                            areaDecoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            hourMinuteDigitDecoration: const BoxDecoration(),
                            hourMinuteDigitTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 240,
                            ),
                            secondDigitDecoration: const BoxDecoration(),
                            amPmDigitTextStyle: const TextStyle(
                                fontSize: 60,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getFuncBtn("ic_floor.svg", () {
                    RouteHelper.pushWidget(context, MyAreaPage());
                  }),
                  getFuncBtn("ic_camera.svg", () {
                    RouteHelper.pushWidget(context, MyCameraPage());
                  }),
                  getFuncBtn("ic_record.svg", () {
                    RouteHelper.pushWidget(context, MyVcrPage());
                  }),
                  getFuncBtn("ic_setting.svg", () {
                    RouteHelper.pushWidget(context, MyScenePage());
                  }),
                ],
              ),

              // Expanded(
              //   child: Column(
              //     children: [
              //       Expanded(
              //         flex: 2,
              //         child: Container(
              //           height: h / 3,
              //           child: ListView.builder(
              //             itemCount: hotelList.length,
              //             scrollDirection: Axis.vertical,
              //             itemBuilder: (BuildContext context, int index) {
              //               final int count =
              //                   hotelList.length > 10 ? 10 : hotelList.length;
              //               final Animation<double> animation =
              //                   Tween<double>(begin: 0.0, end: 1.0).animate(
              //                       CurvedAnimation(
              //                           parent: animationController!,
              //                           curve: Interval((1 / count) * index, 1.0,
              //                               curve: Curves.fastOutSlowIn)));
              //               animationController?.forward();
              //               return NoticeListView(
              //                 callback: () {},
              //                 hotelData: hotelList[index],
              //                 animation: animation,
              //                 animationController: animationController!,
              //               );
              //             },
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getFuncBtn(String icon, Function click) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 20.0),
          child: GestureDetector(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.grey.shade200.withOpacity(0.3),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                "assets/$icon",
                width: 60,
                height: 60,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
            onTap: () {
              click.call();
            },
          ),
        ),
      ),
    );
  }

  updateWeather() {
    HttpUtils().get("https://ipinfo.io/city").then((v) {
      wf.currentWeatherByCityName(v).then((w) {
        weather = w;
        setState(() {});
      });
      // wf.fiveDayForecastByCityName(v).then((ws) {
      //   weathers = ws;
      //   setState(() {});
      // });
    });
  }

  @override
  void dispose() {
    weatherTimer.cancel();
    super.dispose();
  }
}
