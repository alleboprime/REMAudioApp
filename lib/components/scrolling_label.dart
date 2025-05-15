import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class ScrollingLabel extends StatelessWidget {
  final String text;
  final Color color;
  final int maxCharCount;
  final double fontSize;
  final double width; 


  const ScrollingLabel({
    super.key,
    required this.text,
    required this.color,
    required this.maxCharCount,
    required this.width,
    this.fontSize = 17
  });

  @override
  Widget build(BuildContext context) {
    if (text.length <= maxCharCount) {
      return Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
        ),
        overflow: TextOverflow.ellipsis,
      );
    }

    return SizedBox(
      width: width,
      height: 20,
      child: Marquee(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
        ),
        scrollAxis: Axis.horizontal,
        blankSpace: 20.0,
        velocity: 30.0,
        pauseAfterRound: Duration(milliseconds: 500),
        startPadding: 5.0,
        accelerationDuration: Duration(milliseconds: 500),
        accelerationCurve: Curves.linear,
        decelerationDuration: Duration(milliseconds: 500),
        decelerationCurve: Curves.easeOut,
      ),
    );
  }
}