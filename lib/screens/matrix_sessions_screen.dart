import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/components/matrixScreen/matrix_screen_components.dart';
import 'package:rem_app/models/matrix_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MatrixSessionsScreen extends StatefulWidget{
  const MatrixSessionsScreen({super.key});

  @override
  State<MatrixSessionsScreen> createState() => MatrixSessionsScreenState();
}

class MatrixSessionsScreenState extends State<MatrixSessionsScreen>{
  final matrixModel = MatrixModel();

  bool isHovered = false;

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

  Future<void> refresh() async{
    await matrixModel.checkForMatrixConnections();
    setState(() {
      matrixModel.matrixSessions;
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
        appBar: AppBar( //TODO highlighting color still visible when scrolling list view
          toolbarHeight: 100,
          leadingWidth: dimensions.isPc ? 150 : 90,
          backgroundColor: Colors.black,
          foregroundColor: Colors.transparent,
          leading: Row(
            children: [
              SizedBox(width: dimensions.isPc ? 50 : 20),
              ActionButton(iconData: PhosphorIcons.arrowLeft(), action: () => Navigator.pop(context),),
            ],
          ),
          actions: [
            ActionButton(iconData: PhosphorIcons.plus(), action: newConnectionNavigation),
            SizedBox(width: dimensions.isPc ? 30 : 15),
            ActionButton(iconData: PhosphorIcons.arrowClockwise(), action: refresh,),
            SizedBox(width: dimensions.isPc ? 50 : 20),
          ],
          title: Center(child: Text("RECENT CONNECTIONS", style: TextStyle(color: Colors.white, fontSize: dimensions.isPc ? 20 : 15),),)
        ),
        body: Consumer<MatrixModel>(
          builder: (context, matrixModel, child){

            void connect(int index) async {
              String reason = "";
              bool result = await matrixModel.setSocket(index: index);
              if(result){
                result = await matrixModel.establishConnection();
                if(result){
                  if(context.mounted){Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);}
                }else{
                  reason = "Failed websocket connection";
                }
              }else{
                reason = "Failed on setting socket";
              }
              setState(() {
                if(reason != ""){
                  failingReason = reason;
                }
                isLoading = false;
              });
            }

            void removeConnection(int index) async {
              String reason = "";
              bool result = await matrixModel.removeSocket(index);
              if(!result){
                reason = "Failed on removing socket";
              }else{
                refresh();
              }
              setState(() {
                if(reason != ""){
                  failingReason = reason;
                }
                isLoading = false;
              });
              
            }

            return RefreshIndicator(
              displacement: 50,
              backgroundColor: Colors.black,
              onRefresh: refresh,
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                      width: dimensions.isPc ? 400 : 300,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                        child: ListView.builder(
                          itemCount: matrixModel.matrixSessions.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: matrixModel.matrixSessions[index]["latest"] == "true" ? colors.selectionColor : colors.borderColors, width: 2),
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
                                          Icon(matrixModel.matrixSessions[index]["device_type"] == "matrix" ? PhosphorIcons.network() : PhosphorIcons.camera(), size: 25, color: Colors.white,),
                                          Text(matrixModel.matrixSessions[index]["name"].toString(), style: TextStyle(fontSize: dimensions.isPc ? 18 : 16,),),                             
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
                                            child: Text(matrixModel.matrixSessions[index]["ip"].toString(), style: TextStyle(fontSize: dimensions.isPc ? 17 : 15),),
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
                                            child: Text(matrixModel.matrixSessions[index]["port"].toString(), style: TextStyle(fontSize: dimensions.isPc ? 17 : 15),),
                                          ),
                                        ],
                                      ),
                                      ShadButton(
                                        padding: EdgeInsets.all(10),
                                        child: Text("Connect", style: TextStyle(fontSize: dimensions.isPc ? 17 : 15),),
                                        onTapUp: (value){
                                          setState(() {
                                            isLoading = true;
                                          });
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
            );
          },
        ),
      ),
    );
  }
}