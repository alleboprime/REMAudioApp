import 'package:flutter/material.dart';

class HomeNavBarModel extends ChangeNotifier{

  String selectedRoute = "/";

  void setSelectedPage(String route){
    selectedRoute = route;
    notifyListeners();
  }

}