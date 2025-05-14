import 'package:flutter/material.dart';
import 'package:rem_app/models/application_model.dart';

class HomeNavBarModel extends ChangeNotifier{

  final appModel = ApplicationModel();

  late int _selectedPage = appModel.matrixConnected ? 0 : 2;

  int get selectedPage => _selectedPage;
  set selectedPage (int value){
    _selectedPage = value;
    notifyListeners();
  }

  int previousPage = 0;
}