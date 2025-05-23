import 'dart:io';

import 'package:flutter/material.dart';

class Dimensions {
  static final Dimensions _instance = Dimensions._internal();

  factory Dimensions() {
    return _instance;
  }

  Dimensions._internal();

  double screenHeight = 0;
  double screenWidth = 0;

  bool isDesktop = (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

  bool isPc = false;

  bool extremeNarrow = false;

  void init(BuildContext context) {
    screenHeight = MediaQuery.sizeOf(context).height;
    screenWidth = MediaQuery.sizeOf(context).width;

    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    if(screenWidth / devicePixelRatio < 500){
      isPc = false;
      if(screenHeight < 400){
        extremeNarrow = true;
      }else{
        extremeNarrow = false;
      }
    }else{
      isPc = true;
      extremeNarrow = false;
    }
  }

  double get logScreenTextBoxWidht => isPc ? 500 : 300;
  double get logScreenTextBoxHeight=> 50;
  
  double get logScreenButtonWidht => isPc ? 120 : 110;
  double get logScreenButtonHeight => isPc ? 40 : 40;

}
