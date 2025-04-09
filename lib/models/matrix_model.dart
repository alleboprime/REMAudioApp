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
  bool connectionAvailable = false;
  List<String> socketMatrixConnections = [];

  late WebSocket socket;

  late Map<String, bool> inputMute;
  late Map<String, bool> outputMute;
  late Map<String, double> inputVolumes;
  late Map<String, double> outputVolumes;
  late String connectedSocket;
  late int currentPreset;
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

    currentPreset = receivedData["current_preset"] as int;

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

  Future<int> establishConnection() async {
    try {
      socket = await WebSocket.connect(
          "ws://${userModel.remoteServerIp}:8000/ws/app?uuid=$uuid");

      Completer<int> completer = Completer<int> ();

      socket.listen(
        (message) {
          Map<String, dynamic> receivedData = jsonDecode(message);
          print(receivedData);
          updateData(receivedData);
          if (!completer.isCompleted) {
            completer.complete(200);
          }
        },
        onDone: () {
          print('WebSocket closed.');
          if (!completer.isCompleted) {
            completer.complete(200);
          }
        },
        onError: (error) {
          print('WebSocket Error: $error');
          socket.close();
          if (!completer.isCompleted) {
            completer.complete(400);
          }
          //TODO implement _reconnect();
        },
      );

      return completer.future;
    } catch (e) {
      print(e);
      if(e.toString().contains("404")){
        return 404;
      }
      return 400;
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
      print(receivedData);
      if(receivedData["sockets"] != null){
        connectionAvailable = true;
        socketMatrixConnections.clear();
        for(var connection in receivedData["sockets"]){
          socketMatrixConnections.add("${connection["ip"]}:${connection["port"]}");
        }
      }else{
        connectionAvailable = false;
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
