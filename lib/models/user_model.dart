import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserModel extends ChangeNotifier {
  static final UserModel _instance = UserModel._internal();

  factory UserModel() {
    return _instance;
  }

  UserModel._internal();

  String remoteServerIp = "";  

  String accessToken = "";
  bool isAdmin = false;
  
  bool _isLogging = false;
  bool _isLoading = false;
  bool _showDialog = false;

  bool get isLogging => _isLogging;
  bool get isLoading => _isLoading;
  bool get showDialog => _showDialog;

  set isLogging(bool value) {
    _isLogging = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set showDialog(bool value){
    _showDialog = value;
    notifyListeners();
  }

  Future<bool> checkServer(String address) async {
    var url = Uri.http('$address:8000', '/api');
    try {
     await http
          .get(url)              
          .timeout(Duration(seconds: 5));
    } catch (_) {
      remoteServerIp = "";
      return false;
    }
    remoteServerIp = address;
    return true;
  }

  List<dynamic> checkPassword(String password){
    if(password.length < 8){
      return [false, "Password must be at least 8 character"];
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return [false, "Password must contain a capital letter"];
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      return [false, "Password must contain a number"];
    }
    if (!RegExp(r'[\W_]').hasMatch(password)) {
      return [false, "Password must contain a special character"];
    }
    return [true];
  }

  List<dynamic> checkForms(List<dynamic> arguments, {bool checkPasswords = false}) {
    for (String argument in arguments) {
      if (argument.isEmpty) {
        return [false, "All fields must be filled"];
      }
    }
    if (checkPasswords && arguments[2] != arguments[3]) {
      return [false, "Passwords must be the same"];
    }
    if (checkPasswords){
      return checkPassword(arguments[2]);
    }
    return [true];
  }

  Future<List<dynamic>> login(String username, String password) async {
    List<dynamic> checkResults = checkForms([username, password]);
    if (!checkResults[0]) {
      return checkResults;
    }

    Map<String, String> body = {
      'username': username,
      'password': password,
      'session_type': 'native'
    };

    var url = Uri.http('$remoteServerIp:8000', '/api/auth/signin');
    http.Response response;

    try {
      response = await http
          .post(url,
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(body))
          .timeout(Duration(seconds: 5));
    } on TimeoutException catch (_) {
      accessToken = "";
      isAdmin = false;
      return [false, "Request timed out"];
    } on Exception{
      accessToken = "";
      isAdmin = false;
      return [false, "Something Went Wrong"];
    }

    if (response.statusCode == 200) {
      accessToken = jsonDecode(response.body)["access_token"];
      isAdmin = jsonDecode(response.body)["admin"];
      return [true, ""];
    } else {
      accessToken = "";
      isAdmin = false;
      return [false, jsonDecode(response.body)["reason"]];
    }
  }
}
