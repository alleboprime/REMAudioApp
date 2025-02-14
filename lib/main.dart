import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/components/homeNavBar/home_nav_bar.dart';
import 'package:rem_app/models/home_nav_bar_model.dart';
import 'package:rem_app/pages/home_page.dart';
import 'package:rem_app/pages/settings_page.dart';
import 'package:rem_app/pages/audio_page.dart';
import 'package:rem_app/pages/video_page.dart';

main() => runApp(
  ChangeNotifierProvider(
    create: (context) => HomeNavBarModel(),
    child: REMApp(),
    )
  );

class REMApp extends StatelessWidget {
  const REMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.material(
      debugShowCheckedModeBanner: false,
      home: const _REMApp(),
    );
  }
}

class _REMApp extends StatefulWidget {
  const _REMApp();

  @override
  State<_REMApp> createState() => _REMAppState();
}

class _REMAppState extends State<_REMApp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}