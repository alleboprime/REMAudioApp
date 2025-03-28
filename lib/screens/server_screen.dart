import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/components/logScreen/log_screen_components.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/user_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ServerScreen extends StatefulWidget {
  const ServerScreen({super.key});

  @override
  State<ServerScreen> createState() => ServerScreenState();
}

class ServerScreenState extends State<ServerScreen> {
  final TextEditingController serverIpController = TextEditingController();

  UserModel model = UserModel();

  bool isLoading = false;

  bool failed = false;
  String failingReason = "";

  void confirmIp() async {
    setState(() {
      isLoading = true;
      failed = false;
    });
    await Future.delayed(Duration(seconds: 2));
    bool result = await model.checkServer(serverIpController.text);
    if(result){
      if(!mounted)return;
      isLoading = false;
      Navigator.restorablePushNamed(context, "/access");
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
    final colors = AppColors();
    final dimensions = Dimensions();

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child:Consumer<UserModel>(
              builder: (context, model, child) {
                return Stack(
                  children: [
                    Scaffold(
                      resizeToAvoidBottomInset: true,
                      backgroundColor: Colors.black,
                      body: Center(
                        child: SizedBox(
                          width: dimensions.logScreenTextBoxWidht,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    
                                    LogScreenTextBox(
                                      placeholder_: "Server Ip", controller_: serverIpController,
                                    ),
                                    SizedBox(height: 20,),
                                    LogScreenButton(
                                      width_: dimensions.logScreenButtonWidht,
                                      height_: dimensions.logScreenButtonHeight,
                                      text: "Submit",
                                      action: confirmIp,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
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
            )),
    );
  }
}
