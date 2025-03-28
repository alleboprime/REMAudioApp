import 'package:flutter/material.dart';
import 'package:rem_app/components/logScreen/log_screen_components.dart';
import 'package:rem_app/dimensions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage(
      {super.key,
      required this.usernameController,
      required this.passwordController});

  final TextEditingController usernameController;
  final TextEditingController passwordController;

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions();

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
                    placeholder_: "Username",
                    controller_: widget.usernameController),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: dimensions.logScreenTextBoxHeight,
                child: LogScreenTextBox(
                  placeholder_: "Password",
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
