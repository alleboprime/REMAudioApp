import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/components/logScreen/log_screen_components.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/matrix_model.dart';
import 'package:rem_app/models/user_model.dart';
import 'package:rem_app/pages/logPages/login_page.dart';
import 'package:rem_app/pages/logPages/server_ip_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  PageController loginScreenPageController = PageController(initialPage: 0);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController serverIpController = TextEditingController();

  UserModel model = UserModel();

  bool isLoading = false;

  bool failed = false;
  String failingReason = "";

  void login() async {
    setState(() {
      isLoading = true;
      failed = false;
    });

    List<dynamic> response = await model.login(usernameController.text, passwordController.text);
    
    if (response[0]) {
      if(!mounted)return;
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

  void submitIp() async {
    setState(() {
      isLoading = true;
      failed = false;
    });
    await Future.delayed(Duration(seconds: 2));
    bool result = await model.checkServer(serverIpController.text);
    if(result){
      isLoading = false;
      model.isLogging = true;
    }else{
      setState(() {
        isLoading = false;
        failingReason = "Connection Failed";
        failed = true;
      });
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() => failed = false);
        }
      });
    }
  }

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
                if (!model.isLogging) {
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
                    body: Center(
                      child: Column(
                        children: [
                          Expanded(
                            flex: dimensions.extremeNarrow ? 0 : 2,
                            child: dimensions.extremeNarrow
                              ? SizedBox.shrink()
                              : Container(
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
                                  ServerIpPage(serverIpController: serverIpController,),
                                  LoginPage(usernameController: usernameController, passwordController: passwordController,),
                                ]
                              ),
                            )
                          ),
                          Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LogScreenButton(
                                    width_: dimensions.logScreenButtonWidht,
                                    height_: dimensions.logScreenButtonHeight,
                                    text: model.isLogging ? "Log In" : "Submit",
                                    action: model.isLogging ? login : submitIp,
                                  ),
                                  if(model.isLogging)
                                    SizedBox(height: 5,),
                                  if(model.isLogging)
                                    LogScreenText(
                                      text: "Go Back"
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
