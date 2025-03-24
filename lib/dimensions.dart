import 'package:flutter/material.dart';

class Dimensions {
  static final Dimensions _instance = Dimensions._internal();

  factory Dimensions() {
    return _instance;
  }

  Dimensions._internal();

  double screenHeight = 0;
  double screenWidth = 0;

  bool isPc = false;

  void init(BuildContext context) {
    screenHeight = MediaQuery.sizeOf(context).height;
    screenWidth = MediaQuery.sizeOf(context).width;

    print(screenWidth);
    print(screenHeight);

    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    Orientation orientation = MediaQuery.of(context).orientation;

    if(screenWidth / devicePixelRatio < 500){
      isPc = false;
    }else{
      isPc = true;
    }

    print(isPc ? "PC" : "SM");

    //TODO: remove print for debugging

  }

  double get logScreenLogoHeight => screenHeight * 0.1;

  double get logScreenTextBoxWidht => isPc ? 500 : 300;
  
  double get logScreenButtonWidht => isPc ? 150 : 100;
  double get logScreenButtonHeight => isPc ? 50 : 50;


  double get homeScreenAppBarHeight => screenHeight * 0.08;
}
