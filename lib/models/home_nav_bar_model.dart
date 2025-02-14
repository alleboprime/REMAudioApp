import 'package:flutter/material.dart';

class HomeNavBarModel extends ChangeNotifier{

  int selectedPage = 0;

  void setSelectedPage(int index){
    selectedPage = index;
    notifyListeners();
  }

}