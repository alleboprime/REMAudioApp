import 'package:flutter/material.dart';

class Languages extends ChangeNotifier{
  static final Languages _instance = Languages._internal();

  factory Languages() {
    return _instance;
  }

  Languages._internal();

  bool _isEnglish = false;

  bool get isEnglish => _isEnglish;
  set isEnglish(bool value){
    _isEnglish = value;
    notifyListeners();
  }

  final traductions = {
    "RECENT SESSIONS" : "SESSIONI RECENTI",
    "CREATE CONNECTION" : "NUOVA CONNESSIONE",

    "PREFERENCES": "PERSONALIZZAZIONI",
    "Preset\nLabels": "Etichette\nPreset",
    "Channels": "Canali",

    "Sessions": "Sessioni",
    "Change Language": "Cambia Lingua",
    "Change Preferences" : "Personalizzazioni",
    "Log Out" : "Esci",

    "Connect": "Connetti",
    "Submit" : "Conferma",
    "Log In" : "Accedi",
    "Back": "Indietro",
    "Connection test failed": "Test di connessione fallito",

    "Username": "Utente",
    "Password": "Password",
    "Server Ip Address": "Indirizzo Ip Server",

    "Device Name": "Nome Dispositivo",
    "Name": "Nome",
    "Device Ip": "Ip Dispositivo",
    "Device Port": "Porta Dispositivo",
    "Port": "Porta",
    "Device Type": "Tipo Dispositivo",
    "Matrix": "Matrice",
    
    "Failed on removing socket": "Rimozione socket fallita",
    "Failed on setting socket": "Settaggio socket fallito",
    "Failed establishing websocket connection": "Connessione websocket fallita",
    "Failed retrieving sessions": "Sessioni irraggiungibili",
    "Failed retrieving initial token": "Token di connessione mancante",
    "Failed setting preset": "Settaggio preset fallito",

    "Request timed out": "Richiesta interrotta",
    "Something went wrong": "Errore",
    "Wrong Credentials": "Credenziali Errate",
    "All fields must be filled": "Tutti i campi devono essere riempiti",

    "No connection available.\nContact an administrator.": "Nessuna connessione disponibile.\nConttatta un amministratore.",
  };

}