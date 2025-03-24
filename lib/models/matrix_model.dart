import 'dart:io';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class MatrixModel extends ChangeNotifier{
  static final MatrixModel _instance = MatrixModel._internal();

  factory MatrixModel() {
    return _instance;
  }

  MatrixModel._internal();

  final String wsAuthToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJOYXRpdmUiOnsic3ViIjozOSwic2Vzc2lvbl90eXBlIjoibmF0aXZlIn19.HG40BXb_BsUplDUEgZkpmLZNcM-o0D9YHTBJ6dKhNxM";
  final String wsUrl = "wss://1e9b-5-91-111-187.ngrok-free.app/ws/app"; 


  void socketConnect() async{
    try {
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
    }
  }
}