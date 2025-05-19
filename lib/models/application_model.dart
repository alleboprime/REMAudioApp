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

  List<Map<String, String>> sessions = [];

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

  Map<String, bool> inputMute = {};
  Map<String, bool> outputMute = {};
  Map<String, double> inputVolumes = {};
  Map<String, double> outputVolumes = {};
  Map<String, bool> inputVisibility = {};
  Map<String, bool> outputVisibility = {};
  Map<String, String> inputLabels = {};
  Map<String, String> outputLabels = {};

  Map<String, bool> matrixMixMap = {};

  Map<String, String> matrixPresetLabels = {};
  Map<String, String> cameraPresetLabels = {};

  String matrixSocket = "";
  String cameraSocket = "";

  int currentMatrixPreset = 1;
  int currentCameraPreset = 0;

  bool matrixAvailable = true;
  bool cameraAvailable = true;

  Completer<bool>? waitingForMatrixUpdate;

  List<int> valueStack = [];
  bool editingChannelSlider = false;
  String editingChannelSliderDirection = "input";
  String editingChannelSliderNumber = "1";
  Timer? _volumeSendTimer;

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

    matrixMixMap = (receivedData["mix_map"] as Map<String, dynamic>)
      .map((key, value) => MapEntry(key, value as bool));

    currentMatrixPreset = receivedData["current_preset"] as int;

    matrixAvailable = receivedData["available"] as bool;

    matrixSocket = receivedData["matrix_socket"] as String;

    if(waitingForMatrixUpdate != null && !waitingForMatrixUpdate!.isCompleted){
      waitingForMatrixUpdate!.complete(true);
      waitingForMatrixUpdate = null;
    }

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
    var url = Uri.http(userModel.remoteServerIp, '/ws/auth');
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

  Future<bool> establishConnection(String waitingFor) async {
    try {
      socket = await WebSocket.connect(
          "ws://${userModel.remoteServerIp}/ws/app?uuid=$uuid");

      Completer<bool> completer = Completer<bool> ();

      socket?.listen(
        (message) {
          Map<String, dynamic> receivedData = jsonDecode(message);
          if(receivedData.containsKey("reason")){
            manageReasons(receivedData["reason"]);
            if(!completer.isCompleted){
              completer.complete(false);
            }
          }else if(receivedData["device_type"] == "matrix"){
            updateMatrixData(receivedData);
            if(!(completer.isCompleted) && waitingFor == "matrix"){
              completer.complete(true);
            }
          }else{
            updateCameraData(receivedData);
            if(!(completer.isCompleted) && waitingFor == "camera"){
              completer.complete(true);
            }
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
    var url = Uri.http(userModel.remoteServerIp, '/api');
    http.Response response;
    try {
      response = await http.get(url).timeout(Duration(seconds: 5));
    } catch (_) {
      return false;
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> receivedData = jsonDecode(response.body);
      sessions.clear();
      sessionAvailable = false;
      latestMatrixSocketAvailable = false;
      latestCameraSocketAvailable = false;
      if(receivedData["latest_audio_socket"] != null){
        sessionAvailable = true;
        latestMatrixSocketAvailable = true;
        var latest = receivedData["latest_audio_socket"];
        sessions.add({"name":latest["name"], "ip":latest["ip"], "port":latest["port"], "device_type":latest["device_type"], "latest" :"true"});
      }
      if(receivedData["latest_video_socket"] != null){
        sessionAvailable = true;
        latestCameraSocketAvailable = true;
        var latest = receivedData["latest_video_socket"];
        sessions.add({"name":latest["name"], "ip":latest["ip"], "port":latest["port"], "device_type":latest["device_type"], "latest" :"true"});
      }
      if(receivedData["sockets"] != null){
        sessionAvailable = true;
        for(var connection in receivedData["sockets"]){
          sessions.add({"name":connection["name"], "ip":connection["ip"], "port":connection["port"], "device_type":connection["device_type"], "latest" :"false"});
        }
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> setSocket({int index = 0, Map<String, String>? socket}) async {
    var url = Uri.http(userModel.remoteServerIp, '/ws/socket/add', {"uuid":uuid});
    http.Response response;
    Map<String, String> settingSocket;
    if(socket != null){
      settingSocket = socket;
    }else{
      settingSocket = {
        "socket_name": sessions[index]["name"] ?? "",
        "socket": "${sessions[index]["ip"] ?? ""}:${sessions[index]["port"] ?? ""}",
        "device_type": sessions[index]["device_type"] ?? "matrix"
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
    var url = Uri.http(userModel.remoteServerIp, '/ws/socket/remove', {"uuid":uuid});
    http.Response response;
    Map<String, String> settingSocket = sessions[index];
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

  Future<bool> setMatrixPreset(int index) async {
    Map<String, String> command = {
      "section": "matrix_preset",
      "value" : "$index"
    };
    socket?.add(jsonEncode(command));
    waitingForMatrixUpdate = Completer<bool>();
    return waitingForMatrixUpdate!.future.timeout(
      Duration(seconds: 10),
      onTimeout: () {//TODO check wheter timeout is needed
        waitingForMatrixUpdate = null;
        return false;
      },
    );
  }

  void toggleMuteChannel(int channel, String direction, bool status){
    if(direction == "output" && channel == 1){
      Map<String, String> command = {
        "section": "mute",
        "io": "output",
        "channel": "2",
        "value" : "$status"
      };
      socket?.add(jsonEncode(command));
    }
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
      if(inputVisibility[i.toString()] ?? true)socket?.add(jsonEncode(command));
      command = {
        "section": "mute",
        "io": "output",
        "channel": "$i",
        "value" : "true"
      };
      if(outputVisibility[i.toString()] ?? true)socket?.add(jsonEncode(command));
    }
  }

  void toggleChannelVisibility(int channel, String direction, bool status){
    Map<String, String> command = {
      "section": "visibility",
      "io": direction,
      "channel": "$channel",
      "value" : "$status"
    };
    socket?.add(jsonEncode(command));
  }

  void changePresetLabels(String deviceType, String index, String value){
    Map<String, String> command = {
      "section": "${deviceType}_preset_labels",
      "index": index,
      "value" : value
    };
    socket?.add(jsonEncode(command));
  }

  void changeChannelLabels(String direction, String channel, String value){
    Map<String, String> command = {
      "section": "channel_labels",
      "io": direction,
      "channel": channel,
      "value" : value
    };
    socket?.add(jsonEncode(command));
  }

  void startEditingChannelSlider(String direction, String channel){
    editingChannelSlider = true;
    editingChannelSliderDirection = direction;
    editingChannelSliderNumber = channel;

    _volumeSendTimer?.cancel();
    _volumeSendTimer = Timer.periodic(Duration(milliseconds: 22), (_) {
      if (valueStack.isNotEmpty) {
        String value = valueStack.removeLast().toString();
        setChannelVolume(value);
        valueStack.clear();
      }
    });
  }

  void stopEditingChannelSlider() {
    editingChannelSlider = false;
    _volumeSendTimer?.cancel();
    _volumeSendTimer = null;
    valueStack.clear();
}

  void setChannelVolume(String value){
    Map<String, String> command = {
      "section": "volume",
      "io": editingChannelSliderDirection,
      "channel": editingChannelSliderNumber,
      "value" : value
    };
    socket?.add(jsonEncode(command));
  }

  void setMatrixMixMapping(String input, String output, bool value){
    Map<String, String> command = {
      "section": "mix_map",
      "index": input,
      "channel": output,
      "value" : value.toString()
    };
    socket?.add(jsonEncode(command));
  }

  void moveCamera({direction = "up", velocity = "medium", bool resetPosition = false}){
    if(resetPosition){
      Map<String, String> command = {
        "section": "move_camera",
        "direction": "home"
      };
      socket?.add(jsonEncode(command));
    }else{
      Map<String, String> command = {
        "section": "move_camera",
        "direction": direction,
        "velocity": velocity
      };
      socket?.add(jsonEncode(command));
    }
  }

}
