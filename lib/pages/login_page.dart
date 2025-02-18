import 'package:flutter/material.dart';
import 'package:rem_app/components/logScreen/log_screen_components.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginPage extends Container {
  LoginPage({super.key, required this.context});

  final BuildContext context;

  @override
  Widget? get child => Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                  height: MediaQuery.of(context).size.height * 0.10,
                  "assets/rem_logo.svg"),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.11,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.07,
                child: ShadInput(
                  style: TextStyle(fontSize: 17),
                  placeholder: Text("Email"),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.07,
                child: ShadInput(
                  style: TextStyle(fontSize: 17),
                  placeholder: Text("Password"),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.17,
              ),
              LogScreenButton(
                  text: "Sign In",
                  isPrimary: true,
                  height_: MediaQuery.of(context).size.height * 0.07,
                  width_: MediaQuery.of(context).size.height * 0.18),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              LogScreenText(text: "Register"),
            ],
          ),
        ),
      );
}
