import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/components/matrixScreen/matrix_screen_components.dart';
import 'package:rem_app/models/matrix_model.dart';
import 'package:rem_app/models/user_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class NewMatrixSessionScreen extends StatefulWidget {
  const NewMatrixSessionScreen({super.key});

  @override
  State<NewMatrixSessionScreen> createState() => NewMatrixSessionScreenState();
}

class NewMatrixSessionScreenState extends State<NewMatrixSessionScreen> {
  bool isHovered = false;

  final TextEditingController deviceNameController = TextEditingController();
  final TextEditingController deviceIpController = TextEditingController();
  final TextEditingController devicePortController = TextEditingController();

  String _deviceTypeSelectionValue = "matrix";

  Timer? _failedTimer;

  bool isLoading = false;

  bool _failed = false;
  bool get failed => _failed;
  set failed(bool value){
    if(value){
      _failed = true;
      _failedTimer?.cancel();
      _failedTimer = Timer(Duration(seconds: 3), () {
        if(mounted){
          setState(() => _failed = false);
        }
      });
    }else{
      setState(() => _failed = false);
    }
  }

  String _failingReason = "";
  String get failingReason => _failingReason;
  set failingReason(String value){
    _failingReason = value;
    failed = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.black,
          appBar: AppBar( //TODO highlighting color still visible when scrolling list view
            toolbarHeight: 100,
            leadingWidth: 90,
            backgroundColor: Colors.black,
            foregroundColor: Colors.transparent,
            leading: Row(
              children: [
                SizedBox(width: 50),
                ActionButton(iconData: PhosphorIcons.arrowLeft(), action: () => Navigator.pop(context),),
              ],
            ),
            actions: [
              SizedBox(width: 90),
            ],
            title: Center(child: Text("CREATE CONNECTIONS", style: TextStyle(color: Colors.white, fontSize: dimensions.isPc ? 20 : 15),),)
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 30),
              child: Consumer2<UserModel, MatrixModel>(
                builder: (context, userModel, matrixModel, child) {
        
                  void connectToSocket() async {
                    setState(() {
                      isLoading = true;
                    });
                    var socket = {
                      "socket_name": deviceNameController.text,
                      "socket": "${deviceIpController.text}:${devicePortController.text}",
                      "device_type": _deviceTypeSelectionValue
                    };
                    bool result = await matrixModel.setSocket(socket: socket);
                    if(!result){
                      setState(() {
                        failingReason = "Failed setting the socket";
                        isLoading = false;
                      });
                      return;
                    }
                    result = await matrixModel.establishConnection();
                    if(!result){
                      setState(() {
                        failingReason = "Failed establishing connection";
                        isLoading = false;
                      });
                      return;
                    }
                    if(context.mounted){Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);}
                  }
        
                  return userModel.isAdmin
                  ?Stack(
                    children: [
                      Center(
                        child: Container(
                          width: 600,
                          height: 600,
                          decoration: BoxDecoration(
                            color: dimensions.isDesktop ? colors.primaryColor : Colors.transparent,
                            border: Border.all(color: dimensions.isDesktop ? colors.selectionColor : Colors.transparent, width: 2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 30, horizontal: dimensions.isPc ? 60 : 30),
                          child: Center(
                            child: ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                              child: SingleChildScrollView(
                                child: Column(
                                  spacing: 5,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    configurationText("Device Name"),
                                    configurationInput(deviceNameController, "Name"),
                                    SizedBox(height: 10,),
                                    configurationText("Device Ip"),
                                    configurationInput(deviceIpController, "Ip"),
                                    SizedBox(height: 10,),                              
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              configurationText("Device Port"),
                                              configurationInput(devicePortController, "Port"),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              configurationText("Device Type"),
                                              ShadRadioGroup<String>(
                                                initialValue: "matrix",
                                                onChanged: (value) => _deviceTypeSelectionValue = (value ?? ""),
                                                spacing: 5,
                                                items: [
                                                  ShadRadio(
                                                    size: dimensions.isPc ? 12 : 9,
                                                    label: Text('Matrix', style: TextStyle(fontSize: dimensions.isPc ? 15 : 12),),
                                                    value: 'matrix',
                                                  ),
                                                  ShadRadio(
                                                    size: dimensions.isPc ? 12 : 9,
                                                    label: Text('Camera', style: TextStyle(fontSize: dimensions.isPc ? 15 : 12),),
                                                    value: 'camera',
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20,),
                                    Align(
                                      alignment: Alignment.center,
                                      child: ShadButton(
                                        onTapUp: (value) => connectToSocket(),
                                        child: Text("Connect", style: TextStyle(fontSize: dimensions.isPc ? 17 : 15),),
                                      ),
                                    )
                                  ],
                                ),
                              ),
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
                        description: Text(failingReason, style: TextStyle(fontSize: dimensions.isPc ? 17 : 14),),
                      ),
                    ),
                    ],
                  )
                  :Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("x_X", style: TextStyle(fontSize: dimensions.isPc ? 120 : 100, fontWeight: FontWeight.bold),),
                        Text("No connection available.\nContact the administrator.", style: TextStyle(fontSize: dimensions.isPc ? 18 : 15), textAlign: TextAlign.center,)
                      ],
                    ),
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }

  Text configurationText(String value) => Text(value, style: TextStyle(fontSize: dimensions.isPc ? 20 : 17, overflow: TextOverflow.fade), overflow: TextOverflow.fade,);

  ShadInput configurationInput(TextEditingController controller, String placeholder_) => ShadInput(
    controller: controller,
    placeholder: Text(placeholder_, style: TextStyle(fontSize: dimensions.isPc ? 15 : 12),),
    style: TextStyle(fontSize: dimensions.isPc ? 17 : 15),
  );
}