import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/home_nav_bar_model.dart';
import 'package:rem_app/components/homeNavBar/home_nav_bar.dart';
import 'package:rem_app/pages/homePages/audio_page.dart';
import 'package:rem_app/pages/homePages/video_page.dart';
import 'package:rem_app/pages/homePages/settings_page.dart';
import 'package:rem_app/pages/homePages/home_page.dart';


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
                Expanded(flex: 3, child: IndexedStack(
                  index: model.selectedPage,
                  children: [
                    HomePage(),
                    AudioPage(),
                    VideoPage(),
                    SettingsPage(),
                  ],
                ))
              ],
            );
          }
        ),
        bottomNavigationBar: !dimensions.isPc ? HomeNavBar() : null,
        
      ),
    );
  }
}