import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rem_app/models/user_model.dart';

class MatrixModel extends ChangeNotifier {
  static final MatrixModel _instance = MatrixModel._internal();

  factory MatrixModel() {
    return _instance;
  }

  MatrixModel._internal();

  final userModel = UserModel();

  String uuid = "";
  bool sessionAvailable = false;
  List<Map<String, String>> matrixSessions = [];

  late WebSocket socket;

  var test = {
    "1":true,
    "2":false,
    "3":false,
    "4":false,
    "5":false,
    "6":false,
    "7":false,
    "8":false,
    "9":false,
    "10":true,
    "11":false,
    "12":false,
    "13":false,
    "14":false,
    "15":false,
    "16":true,
  };

  late Map<String, bool> inputMute;
  late Map<String, bool> outputMute;
  late Map<String, double> inputVolumes;
  late Map<String, double> outputVolumes;
  late Map<String, bool> inputVisibility;
  late Map<String, bool> outputVisibility;
  late String connectedMatrixSocket;
  late int currentMatrixPreset;
  bool matrixAvailable = true;

  void updateData(Map<String, dynamic> receivedData) {
    inputMute = (receivedData["i_mute"] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value as bool));

    outputMute = (receivedData["o_mute"] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value as bool));

    inputVolumes = (receivedData["i_volumes"] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, (value as num).toDouble()));

    outputVolumes = (receivedData["o_volumes"] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, (value as num).toDouble()));

    inputVisibility = (receivedData["i_visibility"] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value as bool));

    outputVisibility = (receivedData["o_visibility"] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value as bool));

    currentMatrixPreset = receivedData["current_preset"] as int;

    matrixAvailable = receivedData["available"] as bool;

    connectedMatrixSocket = receivedData["matrix_socket"] as String;

    notifyListeners();
  }

  Future<bool> getInitialToken() async {
    var url = Uri.http('${userModel.remoteServerIp}:8000', '/ws/auth');
    http.Response response;
    try {
      response = await http.get(
        url,
        headers: {"Authorization": "Bearer ${userModel.accessToken}"},
      ).timeout(Duration(seconds: 5));
    } catch (_) {
      return false;
    }
    if (response.statusCode == 200) {
      uuid = jsonDecode(response.body)["uuid"];
      return true;
    } else {
      return false;
    }
  }

  Future<bool> establishConnection(BuildContext context) async {
    try {
      socket = await WebSocket.connect(
          "ws://${userModel.remoteServerIp}:8000/ws/app?uuid=$uuid");

      Completer<bool> completer = Completer<bool> ();

      socket.listen(
        (message) {
          Map<String, dynamic> receivedData = jsonDecode(message);
          updateData(receivedData);
          if (!completer.isCompleted) {
            completer.complete(true);
          }
        },
        onDone: () {
          Navigator.pushNamedAndRemoveUntil(context, '/access', (Route<dynamic> route) => false);
          if (!completer.isCompleted) {
            completer.complete(true);
          }
        },
        onError: (error) {
          socket.close();
          if (!completer.isCompleted) {
            completer.complete(false);
          }
        },
      );
      return completer.future;
    } catch (_) {
      return false;
    }
  }

  Future<bool> checkForMatrixConnections() async {
    var url = Uri.http('${userModel.remoteServerIp}:8000', '/api');
    http.Response response;
    try {
      response = await http.get(url).timeout(Duration(seconds: 5));
    } catch (_) {
      return false;
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> receivedData = jsonDecode(response.body);
      if(receivedData["sockets"] != null){
        sessionAvailable = true;
        matrixSessions.clear();
        for (var connection in receivedData["sockets"]){
          matrixSessions.add({"ip":connection["ip"], "port":connection["port"].toString()});
        }
      }else{
        sessionAvailable = false;
      }      
      return true;
    } else {
      return false;
    }
  }

  void toggleMuteChannel(int channel, String direction, bool status){
    Map<String, String> command = {
      "section": "mute",
      "io": direction,
      "channel": "$channel",
      "value" : "$status"
    };
    socket.add(jsonEncode(command));
  }

}
