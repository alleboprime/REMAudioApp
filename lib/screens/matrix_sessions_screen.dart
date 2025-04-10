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
            return Center(
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
                          Align(alignment: Alignment.centerLeft, child: Text("Matrix $index", style: TextStyle(fontSize: dimensions.isPc ? 17 : 15),),),
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
                              )
                            ],
                          )
                        ],
                      ),                      
                    );
                  }
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}