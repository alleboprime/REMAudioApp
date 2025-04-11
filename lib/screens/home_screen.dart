import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/components/logScreen/log_screen_components.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/home_nav_bar_model.dart';
import 'package:rem_app/components/homeNavBar/home_nav_bar.dart';
import 'package:rem_app/models/matrix_model.dart';
import 'package:rem_app/pages/homePages/audio_page.dart';
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
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeNavBarModel(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Consumer<HomeNavBarModel>(
          builder: (context, model, child) {
            return Row(
              children: [
                dimensions.isPc ? HomeNavBar() : Container(),
                Expanded(
                  flex: 3, 
                  child: Consumer<MatrixModel>(
                    builder: (context2, model2, child2){
                      return Stack(
                        children: [
                          IndexedStack(
                            index: model.selectedPage,
                            children: [
                              HomePage(),
                              AudioPage(),
                              VideoPage(),
                              SettingsPage(),
                            ],
                          ),
                          if(!model2.matrixAvailable)
                            Container(
                              color: Colors.black.withAlpha(100),
                              child: Center(
                                child: SizedBox(
                                  width: 235,
                                  child: ShadAlert(
                                    decoration: ShadDecoration(
                                      color: Colors.black,
                                      border: ShadBorder.all(color: Colors.yellow, width: 2)
                                    ),
                                    iconData: LucideIcons.clock,
                                    iconColor: Colors.yellow,
                                    title: Text('Matrix Unavailable', style: TextStyle(color: Colors.yellow, fontSize: 18)),
                                    description:
                                        Text('Please wait...', style: TextStyle(color: Colors.yellow, fontSize: 17),),
                                  ),
                                )
                              ),
                            ),
                          if(!model2.socketConnected)
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
                                    title: Text('Connection Lost', style: TextStyle(color: colors.logScreenToastColor, fontSize: 18)),
                                    description: Column(
                                      spacing: 10,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Something went wrong', style: TextStyle(color: colors.logScreenToastColor, fontSize: 17),),
                                        ShadButton.outline(
                                          onTapUp: (value){
                                            Navigator.pushNamedAndRemoveUntil(context, '/access', (Route<dynamic> route) => false);
                                          }, 
                                          decoration: ShadDecoration(border: ShadBorder.all(color: colors.logScreenToastColor)), 
                                          icon: Icon(PhosphorIcons.signOut(), color: colors.logScreenToastColor, size: 20,), 
                                          child: Text("Exit", style: TextStyle(color: colors.logScreenToastColor),),
                                        ),
                                      ],
                                    )
                                  ),
                                )
                              ),
                            ),
                        ],
                      );
                    },
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
}