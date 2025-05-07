import 'package:flutter/material.dart';

class HomeNavBarModel extends ChangeNotifier{

  int _selectedPage = 0;

  int get selectedPage => _selectedPage;
  set selectedPage (int value){
    _selectedPage = value;
    notifyListeners();
  }
}