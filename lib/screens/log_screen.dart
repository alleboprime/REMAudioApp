import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/components/logScreen/log_screen_components.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/matrix_model.dart';
import 'package:rem_app/models/user_model.dart';
import 'package:rem_app/pages/logPages/login_page.dart';
import 'package:rem_app/pages/logPages/register_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  PageController loginScreenPageController = PageController(initialPage: 0);

  final TextEditingController logEmailController = TextEditingController();
  final TextEditingController logPasswordController = TextEditingController();

  final TextEditingController regEmailController = TextEditingController();
  final TextEditingController regPasswordController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  UserModel model = UserModel();

  bool isLoading = false;

  bool failed = false;
  String failingReason = "";

  void _authenticate(Future<List<dynamic>> Function() authMethod) async {
    setState(() {
      isLoading = true;
      failed = false;
    });

    List<dynamic> response = await authMethod();
    
    if (response[0]) {
      isLoading = false;
      Navigator.restorablePushNamed(context, "/home");
      final matrixModel = MatrixModel();
      matrixModel.socketConnect();
    } else {
      setState(() {
        failingReason = response[1];
        failed = true;
        isLoading = false;
      });

      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() => failed = false);
        }
      });
    }
  }

  void login() {
    _authenticate(
      () => model.login(logEmailController.text, logPasswordController.text),
    );
  }

  void register() {
    _authenticate(
      () => model.register(
        usernameController.text,
        regEmailController.text,
        regPasswordController.text,
        confirmPasswordController.text,
      ),
    );
  }

  //TODO: fix overflow in landscape mode on phone

  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions();

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Consumer<UserModel>(
            builder: (context, model, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (model.isLogging) {
                  loginScreenPageController.animateToPage(
                    0,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                } else {
                  loginScreenPageController.animateToPage(
                    1,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                }
              }
              );

              return Stack(
                children: [
                  Scaffold(
                    resizeToAvoidBottomInset: true,
                    backgroundColor: Colors.black,
                    body: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              colorFilter: ColorFilter.mode(
                                Colors.black.withAlpha(40),
                                BlendMode.srcATop,
                              ),
                              "assets/rem_logo.svg"
                            )
                          )
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            width: dimensions.logScreenTextBoxWidht,
                            child: PageView(
                              physics: NeverScrollableScrollPhysics(),
                              controller: loginScreenPageController,
                              children: [
                                LoginPage(emailController: logEmailController, passwordController: logPasswordController,),
                                RegisterPage(usernameController: usernameController, emailController: regEmailController, passwordController: regPasswordController, confirmPasswordController: confirmPasswordController,),
                              ]
                            ),
                          )
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LogScreenButton(
                                width_: dimensions.logScreenButtonWidht,
                                height_: dimensions.logScreenButtonHeight,
                                text: model.isLogging ? "Log In" : "Sign Up",
                                action: model.isLogging ? login : register,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: LogScreenText(
                                  text: model.isLogging
                                    ? "Sign Up"
                                    : "Log In"
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
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
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: ShadToast(
                        backgroundColor: colors.logScreenToastColor,
                        description: Text(failingReason),
                      ),
                    ),
                ]
              );
              },
          )
        )
    );
  }
}
