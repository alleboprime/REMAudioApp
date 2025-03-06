import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Settings",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            SizedBox(height: 20),
            ShadButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/access', (Route<dynamic> route) => false, arguments: true);
              },
              child: Text("EXIT"),
            ),
          ],
        ),
      ),
    );
  }
}