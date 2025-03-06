import 'package:flutter/material.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/components/logScreen/log_screen_components.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/user_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final bool obscuredPassword = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  bool failed = false;
  String failingReason = "";

  UserModel model = UserModel();

  void login() async {
    setState(() {
      isLoading = true;
      failed = false;
    });

    List<dynamic> response =
        await model.login(emailController.text, passwordController.text);
    if (response[0]) {
      isLoading = false;
      Navigator.restorablePushNamed(context, "/home");
    } else {
      failingReason = response[1];
      setState(() {
        failed = true;
        isLoading = false;
      });
    }
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          failed = false;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions();
    final colors = AppColors();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: dimensions.loginPageLogoContainerHeight,
                    child: SvgPicture.asset(
                        colorFilter: ColorFilter.mode(
                          Colors.black.withAlpha(40),
                          BlendMode.srcATop,
                        ),
                        height: dimensions.loginPageLogoHeight,
                        "assets/rem_logo.svg"),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: dimensions.logScreenFormTopMargin,
                        bottom: dimensions.logScreenFormBottomMargin),
                    height: dimensions.logScreenFormHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: dimensions.logScreenTextBoxWidht,
                          height: dimensions.logScreenTextBoxHeight,
                          child: LogScreenTextBox(
                              placeholder_: "Email",
                              controller_: emailController),
                        ),
                        SizedBox(
                          height: dimensions.logScreenTextBoxSpacing,
                        ),
                        SizedBox(
                          width: dimensions.logScreenTextBoxWidht,
                          height: dimensions.logScreenTextBoxHeight,
                          child: LogScreenTextBox(
                            placeholder_: "Password",
                            controller_: passwordController,
                            isPasswordBox: true,
                          ),
                        ),
                        SizedBox(
                          width: dimensions.logScreenTextBoxWidht,
                          height: dimensions.logScreenTextBoxSpacing,
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: LogScreenText(
                              text: "Forgot Password?",
                              isFormTooltip: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      LogScreenButton(
                        text: "Log In",
                        height_: dimensions.logScreenButtonHeight,
                        width_: dimensions.logScreenButtonWidht,
                        action: login,
                      ),
                      SizedBox(
                        height: dimensions.logScreenButtonSpacing,
                      ),
                      LogScreenText(text: "Sign Up"),
                    ],
                  )
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withAlpha(180),
              child: Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                  ),
                ),
              ),
            ),
          if (failed)
            Positioned(
              bottom: 30,
              left: 30,
              right: 30,
              child: ShadToast(
                backgroundColor: colors.logScreenToastColor,
                description: Text(failingReason),
              ),
            ),
        ]));
  }
}
