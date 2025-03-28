import 'package:flutter/material.dart';
import 'package:rem_app/models/user_model.dart';

class ServerScreen extends StatefulWidget {
  const ServerScreen({super.key});

  @override
  State<ServerScreen> createState() => ServerScreenState();
}

class ServerScreenState extends State<ServerScreen> {
  UserModel model = UserModel();

  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Container());
  }
}
