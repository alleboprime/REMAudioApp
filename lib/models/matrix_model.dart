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

  late Map<String, bool> inputChannelMuted;
  late Map<String, bool> outputChannelMuted;

  late Map<String, double> inputChannelVolume;
  late Map<String, double> outputChannelVolume;

  late Map<String, bool> channelVisibility;
  late int currentPreset;

  void updateData(String message) {
    dynamic decodedMessage = jsonDecode(message);
    inputChannelMuted = decodedMessage["i_mute"];
    outputChannelMuted = decodedMessage["o_mute"];
    inputChannelVolume = decodedMessage["i_volumes"];
    outputChannelVolume = decodedMessage["o_volumes"];
    //TODO wait for visibility features
    //channelVisibility = decodedMessage["visibility"];
    currentPreset = decodedMessage["current_preset"];
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
      // TODO implement socket establishment
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
          //TODO _reconnect();
        },
      );

      return completer.future;
    } catch (_) {
      return false;
    }
  }

}
