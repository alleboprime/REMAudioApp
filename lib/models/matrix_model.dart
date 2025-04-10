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

  late Map<String, bool> inputMute;
  late Map<String, bool> outputMute;
  late Map<String, double> inputVolumes;
  late Map<String, double> outputVolumes;
  late String connectedMatrixSocket; //TODO implement
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

    currentMatrixPreset = receivedData["current_preset"] as int;

    matrixAvailable = receivedData["available"];

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

  Future<bool> establishConnection() async {
    try {
      socket = await WebSocket.connect(
          "ws://${userModel.remoteServerIp}:8000/ws/app?uuid=$uuid");

      Completer<bool> completer = Completer<bool> ();

      socket.listen(
        (message) {
          Map<String, dynamic> receivedData = jsonDecode(message);
          print(receivedData);
          updateData(receivedData);
          if (!completer.isCompleted) {
            completer.complete(true);
          }
        },
        onDone: () {
          print('WebSocket closed.');
          if (!completer.isCompleted) {
            completer.complete(true);
          }
        },
        onError: (error) {
          print('WebSocket Error: $error');
          socket.close();
          if (!completer.isCompleted) {
            completer.complete(false);
          }
          //TODO implement _reconnect();
        },
      );
      return completer.future;
    } catch (e) {
      print(e);
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
