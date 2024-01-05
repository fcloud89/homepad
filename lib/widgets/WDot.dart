import 'package:flutter/material.dart';
import 'package:homepad/theme/WColor.dart';
import 'package:homepad/utils/SizeUtils.dart';

// ignore: must_be_immutable
class WDot extends StatelessWidget {
  final int count;
  final bool showCount;
  final Color? bg;
  String overCountHint; //超出 99 的提示字符
  double height;
  double fontSize;
  double noCountWidth; //小圆点大小

  WDot(
      {this.count = 0,
      this.showCount = false,
      this.bg,
      this.height = 14.0,
      this.fontSize = 12.0,
      this.noCountWidth = 6.0,
      this.overCountHint = "···"});

  @override
  Widget build(BuildContext context) {
    return (count == null || count == 0)
        ? SizedBox()
        : (showCount
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 11.px),
                alignment: Alignment.center,
                constraints: BoxConstraints(minWidth: 14.px),
                height: height.px,
                decoration: BoxDecoration(
                  color: bg ?? WColor.CF36969,
                  borderRadius: BorderRadius.circular((height / 2).px),
                ),
                child: Text(count > 99 ? overCountHint : '$count',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: fontSize.px, color: Colors.white)),
              )
            : Container(
                width: noCountWidth.px,
                height: noCountWidth.px,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular((noCountWidth / 2).px),
                  color: WColor.CF36969,
                ),
              ));
  }
}
