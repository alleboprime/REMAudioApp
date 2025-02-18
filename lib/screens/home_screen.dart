import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/models/home_nav_bar_model.dart';
import 'package:rem_app/components/homeNavBar/home_nav_bar.dart';
import 'package:rem_app/pages/audio_page.dart';
import 'package:rem_app/pages/video_page.dart';
import 'package:rem_app/pages/settings_page.dart';
import 'package:rem_app/pages/home_page.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeNavBarModel(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Consumer<HomeNavBarModel>(
          builder: (context, model, child) {
            return IndexedStack(
              index: model.selectedPage,
              children: [
                HomePage(),
                AudioPage(),
                VideoPage(),
                SettingsPage(),
              ],
            );
          }
        ),
        bottomNavigationBar: HomeNavBar(),
      ),
    );
  }
}