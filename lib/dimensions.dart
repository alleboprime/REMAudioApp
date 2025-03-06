import 'package:flutter/material.dart';

class Dimensions {
  static final Dimensions _instance = Dimensions._internal();

  factory Dimensions() {
    return _instance;
  }

  Dimensions._internal();

  late double screenHeight;
  late double screenWidth;

  void init(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
  }

  double get logScreenFormHeight => 4 * logScreenTextBoxHeight + 2 * logScreenTextBoxSpacing;

  double get loginPageLogoContainerHeight => screenHeight * 0.16;
  double get loginPageLogoHeight => screenHeight * 0.1;
  double get registerPageAvatarSize => screenHeight * 0.16;

  double get logScreenTextBoxWidht => screenWidth * 0.8;
  double get logScreenTextBoxHeight => screenHeight * 0.07;

  double get logScreenButtonHeight => screenHeight * 0.07;
  double get logScreenButtonWidht => screenWidth * 0.4;

  double get logScreenTextBoxSpacing => screenHeight * 0.02;
  double get logScreenButtonSpacing => screenHeight * 0.02;

  double get logScreenFormTopMargin => screenHeight * 0.05;
  double get logScreenFormBottomMargin => screenHeight * 0.05;


  double get homeScreenAppBarHeight => screenHeight * 0.08;
  
}