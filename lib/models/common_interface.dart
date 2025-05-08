import 'dart:async';
import 'package:flutter/material.dart';

//TODO check if setState is useful or can be removed for setting reason or loading values in other pages

class CommonInterface extends ChangeNotifier{
  static final CommonInterface _instance = CommonInterface._internal();

  factory CommonInterface() {
    return _instance;
  }

  CommonInterface._internal();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Timer? _failedTimer;

  bool _failed = false;
  bool get failed => _failed;
  set failed(bool value){
    if(value){
      _failed = true;
      notifyListeners();
      _failedTimer?.cancel();
      _failedTimer = Timer(Duration(seconds: 3), () {
        _failed = false;
        notifyListeners();
      });
    }else{
      _failed = false;
      notifyListeners();
    }
  }

  String _failingReason = "";
  String get failingReason => _failingReason;
  set failingReason(String value){
    _failingReason = value;
    failed = true;
  }
}