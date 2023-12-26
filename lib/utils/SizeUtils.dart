import 'dart:ui';

import 'package:flutter/widgets.dart';

class SizeUtils {
  SizeUtils._();
  static double screenW() {
    return window.physicalSize.width / window.devicePixelRatio;
  }

  static double screenH() {
    return window.physicalSize.height / window.devicePixelRatio;
  }

  static double screenWidthPX() {
    return window.physicalSize.width;
  }

  static double screenHeightPX() {
    return window.physicalSize.height;
  }

  static double statusBar(BuildContext context) {
    return View.of(context).padding.top / View.of(context).devicePixelRatio;
  }

  static double bottomBar() {
    return window.padding.bottom / window.devicePixelRatio;
  }
}

extension doubleFit on double {
  double get px {
    return this * window.physicalSize.width / window.devicePixelRatio / 1920.0;
  }
}

extension intFit on int {
  double get px {
    return this * window.physicalSize.width / window.devicePixelRatio / 1920.0;
  }
}
