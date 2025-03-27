import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rem_app/models/user_model.dart';

class MatrixModel extends ChangeNotifier{
  static final MatrixModel _instance = MatrixModel._internal();

  factory MatrixModel() {
    return _instance;
  }

  MatrixModel._internal();

  final userModel = UserModel();

  String uuid = "";

  Future<String> getInitialToken() async {
    var url = Uri.http('${userModel.remoteServerIp}:8000', '/ws/auth');
    http.Response response;

    try {
      response = await http
          .get(url,
              headers: {"Authorization": userModel.accessToken},)
          .timeout(Duration(seconds: 5));
    }catch (e) {
      print("errore");
      return "";
    }

    if (response.statusCode == 200) {
      print("body: ${jsonDecode(response.body)}");
      return jsonDecode(response.body)["uuid"];
    }else{
      print(response.reasonPhrase);
      return "";
    }
  }

  void socketConnect() async{
    if(uuid == ""){
      uuid = await getInitialToken();
    }
    print("token: ${userModel.accessToken}");
    print("uuid: $uuid");

    /*try {
      final Map<String, dynamic> headers = {
        HttpHeaders.authorizationHeader: "Bearer $wsAuthToken",
      };

      final WebSocket socket = await WebSocket.connect(wsUrl, headers: headers);
      final channel = IOWebSocketChannel(socket);

      print("Connesso al WebSocket");

      channel.stream.listen(
        (message) {
          print("Messaggio ricevuto: $message");
        },
        onError: (error) {
          print("Errore nella connessione: $error");
        },
        onDone: () {
          print("Connessione chiusa");
        },
      );
    } catch (e) {
      print("Errore nella connessione WebSocket: $e");
    }*/
  }
}