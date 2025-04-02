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

  late WebSocket socket;

  late Map<String, dynamic> receivedData;

  late Map<String, bool> inputMute;
  late Map<String, bool> outputMute;

  late Map<String, double> inputVolumes;
  late Map<String, double> outputVolumes;

  late int currentPreset;

  void updateData(String message) {
    receivedData = jsonDecode(message);

    inputMute = (receivedData["i_mute"] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value as bool));

    outputMute = (receivedData["o_mute"] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value as bool));

    inputVolumes = (receivedData["i_volumes"] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, (value as num).toDouble()));

    outputVolumes = (receivedData["o_volumes"] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, (value as num).toDouble()));

    currentPreset = receivedData["current_preset"] as int;

    notifyListeners();
  }

  Future<List<dynamic>> connectSocket() async {
    bool result = await getInitialToken();
    if (!result) {
      return [false, "Failed Retrieving Initial Token"];
    }
    result = await establishConnection();
    if (!result) {
      return [false, "Failed Establishing Connection"];
    }
    return [true, ""];
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

      Completer<bool> completer = Completer<bool>();

      socket.listen(
        (message) {
          updateData(message);
          if (!completer.isCompleted) {
            completer.complete(true);
          }
        },
        onDone: () {
          print('WebSocket closed.');
          if (!completer.isCompleted) {
            completer.complete(false);
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
    } catch (_) {
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
