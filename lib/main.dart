import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/screens/home_screen.dart';
import 'package:rem_app/screens/log_screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'dart:io';

void main() {
  runApp(REMApp());

  if(Platform.isWindows || Platform.isLinux || Platform.isMacOS){
    doWhenWindowReady(() {
    final win = appWindow;
    win.minSize = Size(400, 600);
    win.show();
    });
  }
}

class REMApp extends StatelessWidget {
  const REMApp({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions().init(context);
    return ShadApp.material(
      debugShowCheckedModeBanner: false,
      initialRoute: "/access",
      routes: {
        "/access" : (context) => LoginScreen(),
        "/home" : (context) => HomeScreen(),
      },
      //TODO implement landing page
    );
  }
}

