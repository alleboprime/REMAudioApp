import 'package:flutter/material.dart';
import 'package:rem_app/components/logScreen/log_screen_components.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.emailController, required this.passwordController});

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {

    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogScreenTextBox(
                placeholder_: "Email", controller_: widget.emailController),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: LogScreenTextBox(
                placeholder_: "Password",
                controller_: widget.passwordController,
                isPasswordBox: true,
              ),
            ),
            LogScreenText(
              text: "Forgot Password?",
              isFormTooltip: true,
            ),
          ],
        ),
      ),
    );
  }
}
