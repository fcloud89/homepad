import 'package:flutter/material.dart';
import 'package:homepad/theme/hotel_app_theme.dart';
import 'package:video_player/video_player.dart';

class VideoPopupView extends StatefulWidget {
  const VideoPopupView({Key? key, required this.url}) : super(key: key);

  final String? url;

  @override
  _VideoPopupViewState createState() => _VideoPopupViewState();
}

class _VideoPopupViewState extends State<VideoPopupView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  late VideoPlayerController controller;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    animationController?.forward();
    controller = widget.url!.startsWith('http') ||
            widget.url!.startsWith('rtsp')
        ? VideoPlayerController.networkUrl(Uri.parse(widget.url!))
        : VideoPlayerController.asset(widget.url!)
      ..initialize().then((value) {
        controller.play().then((value) {
          setState(() {});
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.pause();
    controller.dispose();
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedBuilder(
          animation: animationController!,
          builder: (BuildContext context, Widget? child) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: animationController!.value,
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: HotelAppTheme.buildLightTheme().backgroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(4, 4),
                              blurRadius: 8.0),
                        ],
                      ),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24.0)),
                        onTap: () {},
                        child: Container(
                          // width: 480,
                          // height: 360,
                          color: Colors.black,
                          alignment: Alignment.center,
                          child: VideoPlayer(controller),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
