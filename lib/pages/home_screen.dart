import 'dart:async';
import 'dart:ui';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homepad/http/HttpUtils.dart';
import 'package:homepad/model/homelist.dart';
import 'package:homepad/model/msg_list_data.dart';
import 'package:homepad/pages/Notice_list_view.dart';
import 'package:homepad/pages/area_screen.dart';
import 'package:homepad/pages/camera_screen.dart';
import 'package:homepad/pages/scene_screen.dart';
import 'package:homepad/pages/vcr_screen.dart';
import 'package:homepad/utils/AppLocale.dart';
import 'package:homepad/utils/Constant.dart';
import 'package:homepad/utils/RouteHelper.dart';
import 'package:homepad/utils/SizeUtils.dart';
import 'package:homepad/widgets/WDot.dart';
import 'package:homepad/widgets/bg_line.dart';
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
  bool _visible = true;
  List<Weather> weathers = [];
  bool draggable = true;
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
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/imgs/th.webp"), fit: BoxFit.fill)),
        child: SlidingUpPanel(
          backdropEnabled: true,
          // parallaxEnabled: true,
          isDraggable: draggable,
          controller: _panelController,
          slideDirection: SlideDirection.DOWN,
          color: Colors.transparent,
          boxShadow: [],
          minHeight: 70,
          maxHeight: 700,
          margin: const EdgeInsets.symmetric(horizontal: 500),
          collapsed: Container(
            margin: const EdgeInsets.symmetric(horizontal: 380),
            child: GestureDetector(
              onTap: () {
                _panelController.open();
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xff265890), Color(0xFF000000)],
                    tileMode: TileMode.repeated,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/imgs/ic_i.svg",
                      width: 44,
                      height: 44,
                    ),
                    const Text(
                      " 12",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          panelBuilder: (ScrollController sc) => _scrollingList(sc),
          onPanelClosed: () {
            setState(() {
              draggable = true;
            });
          },
          onPanelOpened: () {
            setState(() {
              draggable = false;
            });
          },
          body: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _visible = !_visible;
                  });
                },
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 500),
                  crossFadeState: _visible
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Container(
                    width: w,
                    height: h,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/imgs/bg_cover.jpg"),
                            fit: BoxFit.fill)),
                    child: Column(
                      children: [
                        const Expanded(child: SizedBox()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 800,
                                height: 400,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(left: 80),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: const Offset(0, 0),
                                      blurRadius: 10.0,
                                      spreadRadius: 10.0,
                                    ),
                                  ],
                                ),
                                child: weather == null
                                    ? const SizedBox()
                                    : Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 330,
                                                height: 250,
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 60),
                                                child: Image.network(
                                                  "https://openweathermap.org/themes/openweathermap/assets/vendor/owm/img/widgets/${weather?.weatherIcon}.png",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 20),
                                                child: Text(
                                                  "${weather?.areaName}",
                                                  style: const TextStyle(
                                                    fontSize: 50,
                                                    color: Colors.white,
                                                    shadows: [
                                                      Shadow(
                                                          color: Colors.black,
                                                          blurRadius: 3,
                                                          offset: Offset(3, 3))
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 30, bottom: 40),
                                                child: Text(
                                                  weathers.isEmpty
                                                      ? ""
                                                      : "${weathers[0].tempMin?.fahrenheit?.round()}°F ~ ${weathers[0].tempMax?.fahrenheit?.round()}°F",
                                                  style: const TextStyle(
                                                    fontSize: 80,
                                                    color: Colors.white,
                                                    shadows: [
                                                      Shadow(
                                                          color: Colors.black,
                                                          blurRadius: 3,
                                                          offset: Offset(3, 3))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/imgs/ic_humility.svg",
                                                    width: 100,
                                                    height: 100,
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                            Colors.white,
                                                            BlendMode.srcIn),
                                                  ),
                                                  Text(
                                                    "${weather?.humidity?.round()}%",
                                                    style: const TextStyle(
                                                      fontSize: 120,
                                                      color: Colors.white,
                                                      shadows: [
                                                        Shadow(
                                                            color: Colors.black,
                                                            blurRadius: 3,
                                                            offset:
                                                                Offset(3, 3))
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 80),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(0, 0),
                                    blurRadius: 10.0,
                                    spreadRadius: 10.0,
                                  ),
                                ],
                              ),
                              child: DigitalClock(
                                areaWidth: 800,
                                areaHeight: 400,
                                digitAnimationStyle: Curves.elasticOut,
                                is24HourTimeFormat: false,
                                areaAligment: AlignmentDirectional.center,
                                areaDecoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                hourMinuteDigitDecoration:
                                    const BoxDecoration(),
                                hourMinuteDigitTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 200,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black,
                                        blurRadius: 3,
                                        offset: Offset(3, 3))
                                  ],
                                ),
                                secondDigitDecoration: const BoxDecoration(),
                                secondDigitTextStyle: const TextStyle(
                                  fontSize: 80,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black,
                                        blurRadius: 3,
                                        offset: Offset(3, 3))
                                  ],
                                ),
                                amPmDigitTextStyle: const TextStyle(
                                  fontSize: 70,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black,
                                        blurRadius: 3,
                                        offset: Offset(3, 3))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Expanded(child: SizedBox()),
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            CustomPaint(
                              size: const Size(1400, 300),
                              painter: MyPainter(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                getFuncBtn("ic_vcr.jpg", () {
                                  RouteHelper.pushWidget(context, MyAreaPage());
                                }),
                                getFuncBtn("ic_live.jpg", () {
                                  RouteHelper.pushWidget(
                                      context, MyCameraPage());
                                }),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    getFuncBtn("ic_ring.jpg", () {
                                      RouteHelper.pushWidget(
                                          context, MyVcrPage());
                                    }),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 120, left: 50),
                                      child: WDot(
                                        showCount: true,
                                        count: 12,
                                        fontSize: 24,
                                        height: 40,
                                      ),
                                    )
                                  ],
                                ),
                                getFuncBtn("ic_setting.jpg", () {
                                  RouteHelper.pushWidget(
                                      context, MyScenePage());
                                }),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  secondChild: Container(
                    width: w,
                    height: h,
                    color: Colors.transparent,
                  ),
                ),
              ),
              Container(
                height: 50,
                color: Colors.black.withOpacity(0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 50,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scrollingList(ScrollController sc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 70),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16))),
            child: Container(
              height: 650,
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: hotelList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                      hotelList.length > 10 ? 10 : hotelList.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController?.forward();
                  return NoticeListView(
                    callback: () {},
                    hotelData: hotelList[index],
                    animation: animation,
                    animationController: animationController!,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getFuncBtn(String icon, Function click) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 120),
      child: GestureDetector(
        child: Container(
            width: 200,
            height: 200,
            alignment: Alignment.center,
            child: Image.asset("assets/imgs/$icon")),
        onTap: () {
          click.call();
        },
      ),
    );
  }

  updateWeather() {
    HttpUtils().get("https://ipinfo.io/city").then((v) {
      wf.currentWeatherByCityName(v).then((w) {
        weather = w;
        setState(() {});
      });
      wf.fiveDayForecastByCityName(v).then((ws) {
        weathers = ws;
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    weatherTimer.cancel();
    super.dispose();
  }
}
