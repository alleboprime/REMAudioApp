import 'package:flutter/material.dart';

enum DeviceType { smartphone, tablet, pc }

class Dimensions {
  static final Dimensions _instance = Dimensions._internal();

  factory Dimensions() {
    return _instance;
  }

  Dimensions._internal();

  double screenHeight = 0;
  double screenWidth = 0;


  DeviceType deviceType = DeviceType.smartphone; 

  void init(BuildContext context) {
    screenHeight = MediaQuery.sizeOf(context).height;
    screenWidth = MediaQuery.sizeOf(context).width;

    print(screenWidth);
    print(screenHeight);

    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    Orientation orientation = MediaQuery.of(context).orientation;

    if(screenWidth / devicePixelRatio < 500){
      deviceType = DeviceType.smartphone;
    }else{
      deviceType = DeviceType.pc;
    }

    print(deviceType.name);

    //TODO: remove print for debugging

  }

  double get logScreenLogoHeight => screenHeight * 0.1;

  double get logScreenTextBoxWidht => (deviceType == DeviceType.pc) ? 500 : 300;
  
  double get logScreenButtonWidht => (deviceType == DeviceType.pc) ? 150 : 100;
  double get logScreenButtonHeight => (deviceType == DeviceType.pc) ? 50 : 50;


  double get homeScreenAppBarHeight => screenHeight * 0.08;
}
