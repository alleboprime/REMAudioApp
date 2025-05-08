import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rem_app/models/user_model.dart';

class ApplicationModel extends ChangeNotifier {
  static final ApplicationModel _instance = ApplicationModel._internal();

  factory ApplicationModel() {
    return _instance;
  }

  ApplicationModel._internal();

  final userModel = UserModel();

  String uuid = "";
  bool sessionAvailable = false;
  bool latestMatrixSocketAvailable = false;
  bool latestCameraSocketAvailable = false;
  List<Map<String, String>> matrixSessions = [];

  WebSocket? socket;

  bool _matrixConnected = false;
  bool get matrixConnected => _matrixConnected;
  set matrixConnected(bool value){
    _matrixConnected = value;
    notifyListeners();
  }

  bool _cameraConnected = false;
  bool get cameraConnected => _cameraConnected;
  set cameraConnected(bool value){
    _cameraConnected = value;
    notifyListeners();
  }

  late Map<String, bool> inputMute;
  late Map<String, bool> outputMute;
  late Map<String, double> inputVolumes;
  late Map<String, double> outputVolumes;
  late Map<String, bool> inputVisibility;
  late Map<String, bool> outputVisibility;
  late Map<String, String> inputLabels;
  late Map<String, String> outputLabels;

  late Map<String, String> matrixPresetLabels;
  late Map<String, String> cameraPresetLabels;

  late String matrixSocket;
  late String cameraSocket;

  late int currentMatrixPreset;
  late int currentCameraPreset;

  bool matrixAvailable = true;
  bool cameraAvailable = true;

  void updateMatrixData(Map<String, dynamic> receivedData) {
    matrixConnected = true;

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

    inputLabels = (receivedData["i_labels"] as Map<String, dynamic>)
      .map((key, value) => MapEntry(key, value as String));

    outputLabels = (receivedData["o_labels"] as Map<String, dynamic>)
      .map((key, value) => MapEntry(key, value as String));

    matrixPresetLabels = (receivedData["preset_labels"] as Map<String, dynamic>)
      .map((key, value) => MapEntry(key, value as String));

    currentMatrixPreset = receivedData["current_preset"] as int;

    matrixAvailable = receivedData["available"] as bool;

    matrixSocket = receivedData["matrix_socket"] as String;

    notifyListeners();
  }

  void updateCameraData(Map<String, dynamic> receivedData){
    cameraConnected = true;

    cameraPresetLabels = (receivedData["preset_labels"] as Map<String, dynamic>)
      .map((key, value) => MapEntry(key, value as String));

    cameraAvailable = receivedData["available"] as bool;

    cameraSocket = receivedData["camera_socket"] as String;

    currentCameraPreset = receivedData["current_preset"] as int;
  }

  void manageReasons(String reason){
    if(reason.contains("matrix")){
      matrixConnected = false;
    }else if(reason.contains("camera")){
      cameraConnected = false;
    }
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

      socket?.listen(
        (message) {
          Map<String, dynamic> receivedData = jsonDecode(message);
          print(receivedData);
          if(receivedData.containsKey("reason")){
            manageReasons(receivedData["reason"]);
          }else if(receivedData["device_type"] == "matrix"){
            updateMatrixData(receivedData);
          }else{
            updateCameraData(receivedData);
          }
          if(!completer.isCompleted){
            completer.complete(true);
          }
        },
        onDone: () {
          cameraConnected = false;
          matrixConnected = false;
          if (!completer.isCompleted) {
            completer.complete(true);
          }
        },
        onError: (error) {
          cameraConnected = false;
          matrixConnected = false;
          socket?.close();
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
      matrixSessions.clear();
      sessionAvailable = false;
      latestMatrixSocketAvailable = false;
      latestCameraSocketAvailable = false;
      if(receivedData["latest_audio_socket"] != null){
        sessionAvailable = true;
        latestMatrixSocketAvailable = true;
        var latest = receivedData["latest_audio_socket"];
        matrixSessions.add({"name":latest["name"], "ip":latest["ip"], "port":latest["port"], "device_type":latest["device_type"], "latest" :"true"});
      }
      if(receivedData["latest_video_socket"] != null){
        sessionAvailable = true;
        latestCameraSocketAvailable = true;
        var latest = receivedData["latest_video_socket"];
        matrixSessions.add({"name":latest["name"], "ip":latest["ip"], "port":latest["port"], "device_type":latest["device_type"], "latest" :"true"});
      }
      if(receivedData["sockets"] != null){
        sessionAvailable = true;
        for(var connection in receivedData["sockets"]){
          matrixSessions.add({"name":connection["name"], "ip":connection["ip"], "port":connection["port"], "device_type":connection["device_type"], "latest" :"false"});
        }
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> setSocket({int index = 0, Map<String, String>? socket}) async {
    var url = Uri.http('${userModel.remoteServerIp}:8000', '/ws/socket/add', {"uuid":uuid});
    http.Response response;
    Map<String, String> settingSocket;
    if(socket != null){
      settingSocket = socket;
    }else{
      settingSocket = {
        "socket_name": matrixSessions[index]["name"] ?? "",
        "socket": "${matrixSessions[index]["ip"] ?? ""}:${matrixSessions[index]["port"] ?? ""}",
        "device_type": matrixSessions[index]["device_type"] ?? "matrix"
      };
    }
    try {
      response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(settingSocket),
      ).timeout(Duration(seconds: 5));      
    } catch (_) {
      return false;
    }
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> removeSocket(int index) async {
    var url = Uri.http('${userModel.remoteServerIp}:8000', '/ws/socket/remove', {"uuid":uuid});
    http.Response response;
    Map<String, String> settingSocket = matrixSessions[index];
    try {
      response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "socket": "${settingSocket["ip"]}:${settingSocket["port"]}"
        }),
      ).timeout(Duration(seconds: 5));      
    } catch (_) {
      return false;
    }
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  void toggleMuteChannel(int channel, String direction, bool status){
    Map<String, String> command = {
      "section": "mute",
      "io": direction,
      "channel": "$channel",
      "value" : "$status"
    };
    socket?.add(jsonEncode(command));
  }

  void toggleAllMuteChannel(){
    Map<String, String> command;
    for(int i = 1; i<=inputVisibility.length; i++){
      command = {
      "section": "mute",
      "io": "input",
      "channel": "$i",
      "value" : "true"
    };
    socket?.add(jsonEncode(command));
    command = {
      "section": "mute",
      "io": "output",
      "channel": "$i",
      "value" : "true"
    };
    socket?.add(jsonEncode(command));
    }
  }

}
