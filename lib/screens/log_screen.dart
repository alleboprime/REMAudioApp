import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/components/logScreen/log_screen_components.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/languages.dart';
import 'package:rem_app/models/application_model.dart';
import 'package:rem_app/models/common_interface.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  PageController loginScreenPageController = PageController(initialPage: 0);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController serverIpController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  UserModel model = UserModel();
  final languages = Languages();
  CommonInterface commonInterface = CommonInterface();

  void checkKeyPressed(KeyEvent keyPressed){
    if (keyPressed.logicalKey == LogicalKeyboardKey.enter) {
      model.isLogging ? login() : submitIp();
    }
  }

  void login() async {
    setState(() {
      commonInterface.isLoading = true;
    });
    List<dynamic> loginConnectionResult = await model.login(usernameController.text, passwordController.text);
    String reason = loginConnectionResult[1];
    if (loginConnectionResult[0]) {
      final matrixModel = ApplicationModel();
      
      bool result = await matrixModel.getInitialToken();
      if(result){
        result = await matrixModel.checkForMatrixConnections();
        if(result){
          if(!model.isAdmin && (matrixModel.latestMatrixSocketAvailable || matrixModel.latestCameraSocketAvailable)){
            if(mounted){result = await matrixModel.establishConnection(matrixModel.latestMatrixSocketAvailable ? "matrix" : "camera");}
            if(result){
              if(mounted){Navigator.pushNamed(context, "/home");}
            }else{
              reason = languages.isEnglish ? "Failed establishing websocket connection" : languages.traductions["Failed establishing websocket connection"] ?? "";
            }
          }else if(model.isAdmin && matrixModel.sessionAvailable){
            if(mounted){Navigator.pushNamed(context, "/matrix_connection");}
          }else{
            if(mounted){Navigator.pushNamed(context, "/new_matrix_connection");}
          }
        }else{
          reason = languages.isEnglish ? "Failed retrieving sessions" : languages.traductions["Failed retrieving sessions"] ?? "";
        }
      }else{
        reason = languages.isEnglish ? "Failed retrieving initial token" : languages.traductions["Failed retrieving initial token"] ?? "";
      }
    } 
    setState(() {
      commonInterface.isLoading = false;
      if(reason != ""){
        commonInterface.failingReason = reason;
      }
    });
  }

  void submitIp() async {
    setState(() {
      commonInterface.isLoading = true;
    });
    bool result = await model.checkServer(serverIpController.text);
    if(result){
      commonInterface.isLoading = false;
      model.isLogging = true;
      commonInterface.failed = false;
    }else{
      setState(() {
        commonInterface.isLoading = false;
        commonInterface.failingReason = languages.isEnglish ? "Connection test failed" : languages.traductions["Connection test failed"] ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions();

    return SafeArea(
      child: KeyboardListener(
        onKeyEvent: checkKeyPressed,
        focusNode: _focusNode,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Consumer2<UserModel, Languages>(
              builder: (context, model, languages, child) {
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
        
                return Scaffold(
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
                              padding: EdgeInsets.only(top: 60, left: 50, right: 50),
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
                                  text: model.isLogging ? (languages.isEnglish ? "Log In" : languages.traductions["Log In"] ?? "") : (languages.isEnglish ? "Submit" : languages.traductions["Submit"] ?? ""),
                                  action: model.isLogging ? login : submitIp,
                                ),
                                if(model.isLogging)
                                  SizedBox(height: 5,),
                                if(model.isLogging)
                                  LogScreenText(
                                    text: languages.isEnglish ? "Back" : languages.traductions["Back"] ?? ""
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                );
                },
            )
          ),
      )
    );
  }
}
