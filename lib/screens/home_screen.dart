import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/components/logScreen/log_screen_components.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/languages.dart';
import 'package:rem_app/models/home_nav_bar_model.dart';
import 'package:rem_app/components/homeNavBar/home_nav_bar.dart';
import 'package:rem_app/models/application_model.dart';
import 'package:rem_app/pages/homePages/audio_page.dart';
import 'package:rem_app/pages/homePages/matrix_map_page.dart';
import 'package:rem_app/pages/homePages/preset_page.dart';
import 'package:rem_app/pages/homePages/video_page.dart';
import 'package:rem_app/pages/homePages/settings_page.dart';
import 'package:rem_app/pages/homePages/home_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final dimensions = Dimensions();
  final languages = Languages();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeNavBarModel(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Consumer2<HomeNavBarModel, ApplicationModel>(
          builder: (context, navBarModel, appModel, child) {
            return Row(
              children: [
                dimensions.isPc ? HomeNavBar() : Container(),
                Expanded(
                  flex: 3, 
                  child: Stack(
                    children: [
                      IndexedStack(
                        index: navBarModel.selectedPage,
                        children: [
                          HomePage(),
                          AudioPage(),
                          VideoPage(),
                          SettingsPage(),
                          PresetPage(),
                          MatrixMapPage(),
                        ],
                      ),
                      if(!appModel.matrixAvailable && (navBarModel.selectedPage != 2 && navBarModel.selectedPage != 3 && navBarModel.selectedPage != 4))
                        deviceUnavailable(languages.isEnglish ? "Matrix" : languages.traductions["Matrix"] ?? "", 235),
                      if(!appModel.cameraAvailable && navBarModel.selectedPage == 2 )
                        deviceUnavailable("Camera", 245),
                      if(!(appModel.matrixConnected || appModel.cameraConnected))
                        Container(
                          color: Colors.black.withAlpha(100),
                          child: Center(
                            child: SizedBox(
                              width: 280,
                              child: ShadAlert(
                                decoration: ShadDecoration(
                                  color: Colors.black,
                                  border: ShadBorder.all(color: colors.logScreenToastColor, width: 2)
                                ),
                                iconData: LucideIcons.clock,
                                iconColor: colors.logScreenToastColor,
                                title: Text(languages.isEnglish ? 'Connection Lost' : "Connessione Persa", style: TextStyle(color: colors.logScreenToastColor, fontSize: 18)),
                                description: Column(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(languages.isEnglish ?'Something went wrong' : "Dispositivi non raggiungibili", style: TextStyle(color: colors.logScreenToastColor, fontSize: 17),),
                                    ShadButton.outline(
                                      hoverBackgroundColor: Colors.black,
                                      onTapUp: (value){
                                        Navigator.pushNamedAndRemoveUntil(context, '/access', (Route<dynamic> route) => false);
                                      }, 
                                      decoration: ShadDecoration(border: ShadBorder.all(color: colors.logScreenToastColor)), 
                                      icon: Icon(PhosphorIcons.signOut(), color: colors.logScreenToastColor, size: 20,), 
                                      child: Text(languages.isEnglish ? "Exit" : "Esci", style: TextStyle(color: colors.logScreenToastColor),),
                                    ),
                                  ],
                                )
                              ),
                            )
                          ),
                        ),
                    ],
                  ),
                )
              ],
            );
          }
        ),
        bottomNavigationBar: !dimensions.isPc ? HomeNavBar() : null,
      ),
    );
  }

  Container deviceUnavailable(String device, double width) {
    return Container(
      color: Colors.black.withAlpha(100),
      child: Center(
        child: SizedBox(
          width: width,
          child: ShadAlert(
            decoration: ShadDecoration(
              color: Colors.black,
              border: ShadBorder.all(color: Colors.yellow, width: 2)
            ),
            iconData: LucideIcons.clock,
            iconColor: Colors.yellow,
            title: Text('$device ${languages.isEnglish ? "Unavailable" : "non disponibile"}', style: TextStyle(color: Colors.yellow, fontSize: 18)),
            description:
                Text(languages.isEnglish ? 'Please wait...' : "Attendi...", style: TextStyle(color: Colors.yellow, fontSize: 17),),
          ),
        )
      ),
    );
  }
}