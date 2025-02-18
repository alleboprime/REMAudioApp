import 'package:flutter/material.dart';
import 'package:rem_app/screens/home_screen.dart';
import 'package:rem_app/screens/landing_screen.dart';
import 'package:rem_app/screens/log_screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

main() => runApp(REMApp());

class REMApp extends StatelessWidget {
  const REMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.material(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/" : (context) => LandingScreen(),
        "/login" : (context) => LoginScreen(),
        "/home" : (context) => HomeScreen(),
      },
    );
  }
}

