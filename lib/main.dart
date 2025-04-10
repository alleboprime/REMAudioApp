import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/matrix_model.dart';
import 'package:rem_app/models/user_model.dart';
import 'package:rem_app/screens/home_screen.dart';
import 'package:rem_app/screens/log_screen.dart';
import 'package:rem_app/screens/matrix_sessions_screen.dart';
import 'package:rem_app/screens/new_matrix_session_screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'dart:io';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserModel()),
      ChangeNotifierProvider(create: (context) => MatrixModel()),
    ],
    child: REMApp(),
  ));

  //Setting the minimum window sizes only for PC istances
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
        "/new_matrix_connection" : (context) => NewMatrixSessionScreen(),
        "/matrix_connection" : (context) => MatrixSessionsScreen(),
        "/home" : (context) => HomeScreen(),
      },
      //TODO implement landing page
      //TODO implement matrix connection page for admin
    );
  }
}

