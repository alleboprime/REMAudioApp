import 'package:flutter/material.dart';
import 'package:rem_app/components/logScreen/log_screen_components.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/user_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  bool failed = false;
  String failingReason = "";

  UserModel model = UserModel();

  void register() async {
    setState(() {
      isLoading = true;
      failed = false;
    });

    List<dynamic> response = await model.register(
        usernameController.text,
        emailController.text,
        passwordController.text,
        confirmPasswordController.text);
    if (response[0]) {
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

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
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
                        children: [
                          SizedBox(
                            width: dimensions.logScreenTextBoxWidht,
                            height: dimensions.logScreenTextBoxHeight,
                            child: LogScreenTextBox(
                                placeholder_: "Username",
                                controller_: usernameController),
                          ),
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
                            height: dimensions.logScreenTextBoxHeight,
                            child: LogScreenTextBox(
                              placeholder_: "Confirm Password",
                              controller_: confirmPasswordController,
                              isPasswordBox: true,
                            ),
                          ),
                          SizedBox(
                            width: dimensions.logScreenTextBoxWidht,
                            height: dimensions.logScreenTextBoxSpacing,
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: LogScreenText(
                                text: "Password Requirements",
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
                          text: "Sign Up",
                          height_: dimensions.logScreenButtonHeight,
                          width_: dimensions.logScreenButtonWidht,
                          action: register,
                        ),
                        SizedBox(
                          height: dimensions.logScreenButtonSpacing,
                        ),
                        LogScreenText(text: "Log In"),
                      ],
                    ),
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
                  backgroundColor: Color.fromRGBO(255, 48, 48, 1),
                  description: Text(failingReason),
                ),
              ),
          ],
        ));
  }
}
