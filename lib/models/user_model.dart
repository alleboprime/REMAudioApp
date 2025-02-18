import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier{

  bool _isLogging = true;

  bool get isLogging => _isLogging;

  set isLogging(bool value){
    _isLogging = value; 
    notifyListeners();
  }

  bool isLogged = false;
}