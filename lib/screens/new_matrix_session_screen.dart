import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/components/matrixScreen/matrix_screen_components.dart';
import 'package:rem_app/languages.dart';
import 'package:rem_app/models/application_model.dart';
import 'package:rem_app/models/common_interface.dart';
import 'package:rem_app/models/user_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class NewMatrixSessionScreen extends StatefulWidget {
  const NewMatrixSessionScreen({super.key});

  @override
  State<NewMatrixSessionScreen> createState() => NewMatrixSessionScreenState();
}

class NewMatrixSessionScreenState extends State<NewMatrixSessionScreen> {
  final languages = Languages();

  bool isHovered = false;

  final TextEditingController deviceNameController = TextEditingController();
  final TextEditingController deviceIpController = TextEditingController();
  final TextEditingController devicePortController = TextEditingController();

  String _deviceTypeSelectionValue = "matrix";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.black,
          appBar: AppBar(
            toolbarHeight: 100,
            leadingWidth: dimensions.isPc ? 90 : 90,
            backgroundColor: Colors.black,
            surfaceTintColor: Colors.black,
            foregroundColor: Colors.transparent,
            leading: Row(
              children: [
                SizedBox(width: dimensions.isPc ? 50 : 20),
                ActionButton(iconData: PhosphorIcons.arrowLeft(), primaryAction: () => Navigator.pop(context),),
              ],
            ),
            actions: [
              SizedBox(width: 90),
            ],
            title: Center(child: Text(languages.isEnglish ? "CREATE CONNECTION" : languages.traductions["CREATE CONNECTION"] ?? "", style: TextStyle(color: Colors.white, fontSize: dimensions.isPc ? 20 : 15),),)
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 30),
              child: Consumer3<UserModel, ApplicationModel, CommonInterface>(
                builder: (context, userModel, appModel, commonInterface, child) {
        
                  void connectToSocket() async {
                    setState(() {
                      commonInterface.isLoading = true;
                    });
                    var socket = {
                      "socket_name": deviceNameController.text,
                      "socket": "${deviceIpController.text}:${devicePortController.text}",
                      "device_type": _deviceTypeSelectionValue
                    };
                    bool result = await appModel.setSocket(socket: socket);
                    if(!result){
                      setState(() {
                        commonInterface.failingReason = languages.isEnglish ? "Failed on setting socket" : languages.traductions["Failed on setting socket"] ?? "";
                        commonInterface.isLoading = false;
                      });
                      return;
                    }
                    result = await appModel.establishConnection(_deviceTypeSelectionValue == "matrix" ? "matrix" : "camera");
                    if(!result){
                      setState(() {
                        commonInterface.failingReason = languages.isEnglish ? "Failed establishing websocket connection" : languages.traductions["Failed establishing websocket connection"] ?? "";
                        commonInterface.isLoading = false;
                      });
                      return;
                    }
                    commonInterface.isLoading = false;
                    if(context.mounted){Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);}
                  }
        
                  return userModel.isAdmin
                  ?Center(
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
                                configurationText(languages.isEnglish ? "Device Name" : languages.traductions["Device Name"] ?? ""),
                                configurationInput(deviceNameController, languages.isEnglish ? "Name" : languages.traductions["Name"] ?? ""),
                                SizedBox(height: 10,),
                                configurationText(languages.isEnglish ? "Device Ip" : languages.traductions["Device Ip"] ?? ""),
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
                                          configurationText(languages.isEnglish ? "Device Port" : languages.traductions["Device Port"] ?? ""),
                                          configurationInput(devicePortController, languages.isEnglish ? "Port" : languages.traductions["Port"] ?? ""),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          configurationText(languages.isEnglish ? "Device Type" : languages.traductions["Device Type"] ?? ""),
                                          ShadRadioGroup<String>(
                                            initialValue: "matrix",
                                            onChanged: (value) => _deviceTypeSelectionValue = (value ?? ""),
                                            spacing: 5,
                                            items: [
                                              ShadRadio(
                                                size: dimensions.isPc ? 12 : 9,
                                                label: Text(languages.isEnglish ? "Matrix" : languages.traductions["Matrix"] ?? "", style: TextStyle(fontSize: dimensions.isPc ? 15 : 12),),
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
                                    child: Text(languages.isEnglish ? "Connect" : languages.traductions["Connect"] ?? "" , style: TextStyle(fontSize: dimensions.isPc ? 17 : 15),),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  )
                  :Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("x_X", style: TextStyle(fontSize: dimensions.isPc ? 120 : 100, fontWeight: FontWeight.bold),),
                        Text(languages.isEnglish ? "No connection available.\nContact an administrator." : languages.traductions["No connection available.\nContact an administrator."] ?? "", style: TextStyle(fontSize: dimensions.isPc ? 18 : 15), textAlign: TextAlign.center,)
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