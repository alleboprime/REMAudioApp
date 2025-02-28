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

  bool _isLogging = true;

  bool get isLogging => _isLogging;

  set isLogging(bool value) {
    _isLogging = value;
    notifyListeners();
  }

  String jwtSecret = "";

  //TODO error detection improvement

  Future<List<dynamic>> register(String username, String email, String password) async {
    Map<String, String> body = {
      'username': username,
      'email': email,
      'password': password,
      'session_type': 'native'
    };

    var url = Uri.http('192.168.1.11:8000', '/api/auth/register');

    http.Response response;

    try {
      response = await http
          .post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(body))
          .timeout(Duration(seconds: 5));
    } on TimeoutException catch (_) {
      jwtSecret = "";
      return [false, "Request timed out"];
    } on Exception catch (e) {
      jwtSecret = "";
      return [false, e.toString()];
    }
    if (response.statusCode == 200) {
      jwtSecret = jsonDecode(response.body)["jwt_token"];
      return [true];
    } else {
      jwtSecret = "";
      return [false, jsonDecode(response.body)["reason"]];
    }
  }

  Future<List<dynamic>> login(String email, String password) async {
    Map<String, String> body = {
      'email': email,
      'password': password,
      'session_type': 'native'
    };

    var url = Uri.http('192.168.1.11:8000', '/api/auth/signin');

    http.Response response;

    try {
      response = await http
          .post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(body))
          .timeout(Duration(seconds: 5));
    } on TimeoutException catch (_) {
      jwtSecret = "";
      return [false, "Request timed out"];
    } on Exception catch (e) {
      jwtSecret = "";
      return [false, e.toString()];
    }

    if (response.statusCode == 200) {
      jwtSecret = jsonDecode(response.body)["jwt_token"];
      return [true];
    } else {
      jwtSecret = "";
      return [false, jsonDecode(response.body)["reason"]];
    }
  }
}
