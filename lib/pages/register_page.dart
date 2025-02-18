import 'package:flutter/material.dart';
import 'package:rem_app/components/logScreen/log_screen_components.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RegisterPage extends Container{
  RegisterPage({super.key, required this.context});

  final BuildContext context;

  late final screenWidth = MediaQuery.of(context).size.width;
  late final screenHeight = MediaQuery.of(context).size.height;

  @override
  Widget? get child => Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShadAvatar("assets/default_avatar.svg",
                size: Size(
                  MediaQuery.of(context).size.height * 0.16,
                  MediaQuery.of(context).size.height * 0.16,
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            LogScreenTextBox(
              width_: screenWidth,
              height_: screenHeight,
              placeholder: "Username",
            ),
            LogScreenTextBox(
              width_: screenWidth,
              height_: screenHeight,
              placeholder: "Email",
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            LogScreenTextBox(
              width_: screenWidth,
              height_: screenHeight,
              placeholder: "Password",
            ),
            LogScreenTextBox(
              width_: screenWidth,
              height_: screenHeight,
              placeholder: "Confirm Password",
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            LogScreenButton(
                text: "Register",
                isPrimary: true,
                height_: MediaQuery.of(context).size.height * 0.07,
                width_: MediaQuery.of(context).size.height * 0.18
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            LogScreenText(text: "Sign In"),
          ],
        ),
      ),
    );
}