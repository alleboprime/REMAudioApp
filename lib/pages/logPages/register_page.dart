import 'package:flutter/material.dart';
import 'package:rem_app/components/logScreen/log_screen_components.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.usernameController, required this.emailController, required this.passwordController, required this.confirmPasswordController});

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController usernameController;
  final TextEditingController confirmPasswordController;

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  @override
  Widget build(BuildContext context) {

    return Container(
      alignment: Alignment.center,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogScreenTextBox(
                  placeholder_: "Username", controller_: widget.usernameController),
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
              LogScreenTextBox(
                  placeholder_: "Confirm Password",
                  controller_: widget.confirmPasswordController,
                  isPasswordBox: true,
                ),
              LogScreenText(
                text: "Password Requirements",
                isFormTooltip: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
