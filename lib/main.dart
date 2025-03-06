import 'package:flutter/material.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/screens/home_screen.dart';
import 'package:rem_app/screens/log_screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

main() => runApp(REMApp());

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
      //TODO implement check access, landing page / progress indicator for access.
    );
  }
}

