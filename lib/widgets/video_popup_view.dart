import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        : VideoPlayerController.file(File(widget.url!))
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
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(40.0),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(18.0)),
                          child: VideoPlayer(controller),
                        ),
                      ),
                      SvgPicture.asset(
                        "assets/imgs/ic_close.svg",
                        width: 50,
                        height: 50,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ],
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
