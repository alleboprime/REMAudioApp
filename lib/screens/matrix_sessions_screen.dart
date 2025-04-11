import 'dart:async';

import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leadingWidth: 100,
          toolbarHeight: 100,
          backgroundColor: Colors.transparent,
          leading: ArrowBackMatrixScreen(),
        ),
        body: Consumer<MatrixModel>(
          builder: (context, matrixModel, child){

            void connect(Map<String, String> matrix) async {
              String reason = "";
              await matrixModel.socket?.close();
              //matrixModel.setSocket();
              bool result = await matrixModel.establishConnection(context);
              if(result){
                Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
              }else{
                reason = "Something went wrong";
              }
              setState(() {
                if(reason != ""){
                  failingReason = reason;
                }
                isLoading = false;
              });
            }

            return Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: dimensions.isPc ? 400 : 300,
                    child: ListView.builder(
                      itemCount: matrixModel.matrixSessions.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: colors.borderColors, width: 2),
                            color: colors.primaryColor
                          ),
                          padding: EdgeInsets.all(dimensions.isPc ? 25 : 20),
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            spacing: dimensions.isPc ? 10 : 5,
                            children: [
                              Align(alignment: Alignment.centerLeft, child: Text(matrixModel.matrixSessions[index]["name"].toString(), style: TextStyle(fontSize: dimensions.isPc ? 17 : 15),),),
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
                                      connect(matrixModel.matrixSessions[index]);
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
            );
          },
        ),
      ),
    );
  }
}