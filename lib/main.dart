import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/application_model.dart';
import 'package:rem_app/models/common_interface.dart';
import 'package:rem_app/models/user_model.dart';
import 'package:rem_app/screens/home_screen.dart';
import 'package:rem_app/screens/log_screen.dart';
import 'package:rem_app/screens/matrix_sessions_screen.dart';
import 'package:rem_app/screens/new_matrix_session_screen.dart';
import 'package:rem_app/screens/preferences_screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'dart:io';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserModel()),
      ChangeNotifierProvider(create: (context) => ApplicationModel()),
      ChangeNotifierProvider(create: (context) => CommonInterface()),
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
        "/access": (context) => LoginScreen(),
        "/new_matrix_connection": (context) => NewMatrixSessionScreen(),
        "/matrix_connection": (context) => MatrixSessionsScreen(),
        "/preferences": (context) => PreferencesScreen(),
        "/home": (context) => HomeScreen(),
      },
      builder: (context, child) {
        final colors = AppColors();

        return Consumer<CommonInterface>(
          builder: (context, commonInterface, child1){
            return Stack(
              children: [
                child!,
                if (commonInterface.isLoading)
                  Container(
                    color: Colors.black.withAlpha(180),
                    child: const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(strokeWidth: 5),
                      ),
                    ),
                  ),
                if (commonInterface.failed)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: ShadToast(
                      backgroundColor: colors.logScreenToastColor,
                      description: Text(
                        commonInterface.failingReason,
                        style: TextStyle(fontSize: Dimensions().isPc ? 17 : 14),
                      ),
                    ),
                  ),
              ],
            );
          }
        );
      },
    );
  }
}

