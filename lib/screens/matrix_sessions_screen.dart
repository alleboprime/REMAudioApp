import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/components/matrixScreen/matrix_screen_components.dart';
import 'package:rem_app/models/application_model.dart';
import 'package:rem_app/models/common_interface.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MatrixSessionsScreen extends StatefulWidget{
  const MatrixSessionsScreen({super.key});

  @override
  State<MatrixSessionsScreen> createState() => MatrixSessionsScreenState();
}

class MatrixSessionsScreenState extends State<MatrixSessionsScreen>{
  final appModel = ApplicationModel();

  bool isHovered = false;

  Future<void> refresh() async{
    await appModel.checkForMatrixConnections();
    setState(() {
      appModel.sessions;
    });
    return;
  }

  Future<void> newConnectionNavigation() async{
    Navigator.pushNamed(context, "/new_matrix_connection");
    return;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 100,
          surfaceTintColor: Colors.black,
          leadingWidth: dimensions.isPc ? 150 : 90,
          backgroundColor: Colors.black,
          foregroundColor: Colors.transparent,
          leading: Row(
            children: [
              SizedBox(width: dimensions.isPc ? 50 : 20),
              ActionButton(iconData: PhosphorIcons.arrowLeft(), primaryAction: () => Navigator.pop(context),),
            ],
          ),
          actions: [
            ActionButton(iconData: PhosphorIcons.plus(), primaryAction: newConnectionNavigation),
            SizedBox(width: dimensions.isPc ? 30 : 15),
            ActionButton(iconData: PhosphorIcons.arrowClockwise(), primaryAction: refresh,),
            SizedBox(width: dimensions.isPc ? 50 : 20),
          ],
          title: Center(child: Text("RECENT CONNECTIONS", style: TextStyle(color: Colors.white, fontSize: dimensions.isPc ? 20 : 15),),)
        ),
        body: Consumer2<ApplicationModel, CommonInterface>(
          builder: (context, appModel, commonInterface, child){

            void connect(int index) async {
              setState(() {
                commonInterface.isLoading = true;
              });
              appModel.socket?.close();
              String reason = "";
              bool result = await appModel.setSocket(index: index);
              if(result){
                result = await appModel.establishConnection(appModel.sessions[index]["device_type"] == "matrix" ? "matrix" : "camera");
                if(result){
                  commonInterface.isLoading = false;
                  if(context.mounted){Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);}
                }else{
                  reason = "Failed websocket connection";
                }
              }else{
                reason = "Failed on setting socket";
              }
              setState(() {
                commonInterface.isLoading = false;
                if(reason != ""){
                  commonInterface.failingReason = reason;
                }
              });
            }

            void removeConnection(int index) async {
              setState(() {
                commonInterface.isLoading = true;
              });
              String reason = "";
              bool result = await appModel.removeSocket(index);
              if(!result){
                reason = "Failed on removing socket";
              }else{
                commonInterface.isLoading = false;
                refresh();
              }
              setState(() {
                commonInterface.isLoading = false;
                if(reason != ""){
                  commonInterface.failingReason = reason;
                }
              });
              
            }

            return RefreshIndicator(
              displacement: 50,
              backgroundColor: Colors.black,
              onRefresh: refresh,
              child: Center(
                child: SizedBox(
                  width: dimensions.isPc ? 400 : 300,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                    child: ListView.builder(
                      itemCount: appModel.sessions.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: appModel.sessions[index]["latest"] == "true" ? colors.selectionColor : colors.borderColors, width: 2),
                            color: colors.primaryColor
                          ),
                          padding: EdgeInsets.all(dimensions.isPc ? 25 : 20),
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            spacing: dimensions.isPc ? 10 : 5,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [                                      
                                  Row(
                                    spacing: 10,
                                    children: [
                                      Icon(appModel.sessions[index]["device_type"] == "matrix" ? PhosphorIcons.hardDrive() : PhosphorIcons.camera(), size: 25, color: Colors.white,),
                                      Text(appModel.sessions[index]["name"].toString(), style: TextStyle(fontSize: dimensions.isPc ? 18 : 16,),),                             
                                    ],
                                  ),
                                  ShadButton.destructive(icon: Icon(PhosphorIcons.trash(), size: 16,), padding: EdgeInsets.all(0), onTapUp: (value) => removeConnection(index),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                                          border: Border.all(color: colors.borderColors, width: 2),
                                        ),
                                        padding: EdgeInsets.all(dimensions.isPc ? 15 : 10),
                                        child: Text(appModel.sessions[index]["ip"].toString(), style: TextStyle(fontSize: dimensions.isPc ? 17 : 15),),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
                                          border: Border(
                                            left: BorderSide.none,
                                            top: BorderSide(color: colors.borderColors, width: 2),
                                            right: BorderSide(color: colors.borderColors, width: 2),
                                            bottom: BorderSide(color: colors.borderColors, width: 2),
                                          ),
                                        ),
                                        padding: EdgeInsets.all(dimensions.isPc ? 15 : 10),
                                        child: Text(appModel.sessions[index]["port"].toString(), style: TextStyle(fontSize: dimensions.isPc ? 17 : 15),),
                                      ),
                                    ],
                                  ),
                                  ShadButton(
                                    padding: EdgeInsets.all(8),
                                    child: Text("Connect", style: TextStyle(fontSize: dimensions.isPc ? 17 : 15),),
                                    onTapUp: (value){
                                      connect(index);
                                    },
                                  )
                                ],
                              )
                            ],
                          ),                      
                        );
                      }
                    ),
                  ),
                ),
              )
            );
          },
        ),
      ),
    );
  }
}