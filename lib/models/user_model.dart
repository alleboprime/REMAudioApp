import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final String remoteIp = "192.168.1.11";

class UserModel extends ChangeNotifier {
  UserModel();

  bool _isLogging = true;
  bool _isLoading = false;

  bool get isLogging => _isLogging;
  bool get isLoading => _isLoading;

  set isLogging(bool value) {
    _isLogging = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String accessToken = "";

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

  Future<List<dynamic>> register(String username, String email, String password, String confirmPassword) async {
    List<dynamic> checkResults = checkForms(
        [username, email, password, confirmPassword],
        checkPasswords: true);
    if (!checkResults[0]) {
      return checkResults;
    }

    Map<String, String> body = {
      'username': username,
      'email': email,
      'password': password,
      'session_type': 'native'
    };

    var url = Uri.http('$remoteIp:8000', '/api/auth/register');

    http.Response response;

    try {
      response = await http
          .post(url,
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(body))
          .timeout(Duration(seconds: 5));
    } on TimeoutException catch (_) {
      accessToken = "";
      return [false, "Request timed out"];
    } on Exception catch (e) {
      accessToken = "";
      return [false, e.toString()];
    }
    if (response.statusCode == 200) {
      accessToken = jsonDecode(response.body)["access_token"];
      return [true];
    } else {
      accessToken = "";
      return [false, jsonDecode(response.body)["reason"]];
    }
  }

  Future<List<dynamic>> login(String email, String password) async {
    List<dynamic> checkResults = checkForms([email, password]);
    if (!checkResults[0]) {
      return checkResults;
    }

    Map<String, String> body = {
      'email': email,
      'password': password,
      'session_type': 'native'
    };

    var url = Uri.http('$remoteIp:8000', '/api/auth/signin');
    http.Response response;

    try {
      response = await http
          .post(url,
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(body))
          .timeout(Duration(seconds: 5));
    } on TimeoutException catch (_) {
      accessToken = "";
      return [false, "Request timed out"];
    } on Exception catch (e) {
      accessToken = "";
      return [false, e.toString()];
    }

    if (response.statusCode == 200) {
      accessToken = jsonDecode(response.body)["access_token"];
      return [true];
    } else {
      accessToken = "";
      return [false, jsonDecode(response.body)["reason"]];
    }
  }
}
