import 'package:flutter/material.dart';
import 'package:rem_app/components/logScreen/log_screen_components.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/languages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage(
      {super.key,
      required this.usernameController,
      required this.passwordController});

  final TextEditingController usernameController;
  final TextEditingController passwordController;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions();
    final languages = Languages();

    return Container(
      alignment: Alignment.center,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: dimensions.logScreenTextBoxHeight,
                child: LogScreenTextBox(
                    placeholder_: languages.isEnglish ? "Username" : languages.traductions["Username"] ?? "",
                    controller_: widget.usernameController),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: dimensions.logScreenTextBoxHeight,
                child: LogScreenTextBox(
                  placeholder_: languages.isEnglish ? "Password" : languages.traductions["Password"] ?? "",
                  controller_: widget.passwordController,
                  isPasswordBox: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
