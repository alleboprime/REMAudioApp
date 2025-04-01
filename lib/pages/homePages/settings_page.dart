import 'package:flutter/material.dart';
import 'package:rem_app/models/matrix_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final matrixModel = MatrixModel();
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
                matrixModel.socket.close();
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