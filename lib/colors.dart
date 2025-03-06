import 'package:flutter/material.dart';

class AppColors {
  static final AppColors _instance = AppColors._internal();

  factory AppColors() {
    return _instance;
  }

  AppColors._internal();

  Color get primaryColor => Color.fromRGBO(30, 30, 30, 1);

  Color get selectionColor => Color.fromRGBO(0, 122, 255, 1);

  Color get logScreenButtonColor => Color.fromRGBO(250, 250, 250, 1);

  Color get logScreenToastColor => Color.fromRGBO(255, 48, 48, 1);

  Color get logScreenFormTooltip => Color.fromRGBO(133, 147, 166, 1);

}