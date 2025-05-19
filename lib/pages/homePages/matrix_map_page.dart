import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/components/matrixScreen/matrix_screen_components.dart';
import 'package:rem_app/components/scrolling_label.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/application_model.dart';
import 'package:rem_app/models/home_nav_bar_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MatrixMapPage extends StatefulWidget {
  const MatrixMapPage({super.key});

  @override
  MatrixMapPageState createState() => MatrixMapPageState();
}

class MatrixMapPageState extends State<MatrixMapPage> {

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    final dimensions = Dimensions();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 100,
          surfaceTintColor: Colors.black,
          leadingWidth: dimensions.isPc ? 150 : 90,
          backgroundColor: Colors.black,
          foregroundColor: Colors.transparent,
          leading: Consumer<HomeNavBarModel>(
            builder: (context, navBar, child) {
              return Row(
                children: [
                  SizedBox(width: dimensions.isPc ? 50 : 20),
                  ActionButton(iconData: PhosphorIcons.arrowLeft(), action: () => navBar.selectedPage = navBar.previousPage,),
                ],
              );
            }
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 600,
                maxHeight: 600,
              ),
              decoration: BoxDecoration(
                color: dimensions.isDesktop ? colors.primaryColor : Colors.black,
                border: Border.all(color: dimensions.isDesktop ? colors.selectionColor : Colors.transparent, width: 2),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.all(30),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox.shrink(),
                        ),
                        Expanded(
                          flex: 8,
                          child: Center(child: RotatedBox(quarterTurns: -1, child: Text("Output Channels", style: TextStyle(fontSize: dimensions.isPc ? 22 : 18),),),),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Center(child: Text("Input Channels", style: TextStyle(fontSize: dimensions.isPc ? 22 : 18),),),
                        ),
                        Expanded(
                          flex: 8,
                          child: Consumer<ApplicationModel>(
                            builder: (context, appModel, child) {
                              final inputCount = appModel.inputLabels.length;
                              final cellSize = 50.0;
        
                              Map<String, String> inputLabels = appModel.inputLabels;
                              Map<String, String> outputLabels = appModel.outputLabels;
        
                              Map<String, bool> mixMap = appModel.matrixMixMap;
        
                              bool checkOutput(int outputIndex){
                                for(var entry in mixMap.entries){
                                  String output = entry.key.split(",")[1].replaceFirst(")", "");
                                  if(outputIndex.toString() == output.toString() && entry.value){
                                    return false;
                                  }
                                }
                                return true;
                              }
        
                              return InteractiveViewer(
                                constrained: false,
                                minScale: 1,
                                maxScale: 1,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: List.generate(
                                          inputCount + 1,
                                          (index) => Container(
                                            width: cellSize,
                                            height: cellSize,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                right:  index < 8
                                                    ? BorderSide(color: Colors.white)
                                                    : BorderSide.none,
                                              ),
                                            ),
                                            child: index == 0
                                                ? const SizedBox()
                                                : Center(
                                                    child: ScrollingLabel(
                                                      text: inputLabels[index.toString()] ?? "ch $index", 
                                                      color: Colors.white, 
                                                      maxCharCount: 4, 
                                                      width: 35
                                                    )
                                                  ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: inputCount * cellSize,
                                        width: (inputCount + 1) * cellSize,
                                        child: ListView.builder(
                                          itemCount: inputCount,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, row) {
                                            return Row(
                                              children: List.generate(
                                                inputCount + 1,
                                                (col) {
                                                  if (col == 0) {
                                                    final isLastRow = row == inputCount - 1;
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          top: row == 0 
                                                              ? BorderSide(color: Colors.white)
                                                              : BorderSide.none,
                                                          bottom: !isLastRow
                                                              ? BorderSide(color: Colors.white)
                                                              : BorderSide.none,
                                                          right: BorderSide(color: Colors.white)
                                                        ),
                                                      ),
                                                      width: cellSize,
                                                      height: cellSize,
                                                      child: Center(
                                                        child: ScrollingLabel(
                                                          text: outputLabels[(row + 1).toString()] ?? "ch ${row + 1}", 
                                                          color: Colors.white, 
                                                          maxCharCount: 4, 
                                                          width: 35
                                                        )
                                                      ),
                                                    );
                                                  }
                                                  return SizedBox(
                                                    width: cellSize,
                                                    height: cellSize,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          top: row == 0
                                                              ? BorderSide(color: Colors.white)
                                                              : BorderSide.none,
                                                          bottom: row < 7
                                                              ? BorderSide(color: Colors.white)
                                                              : BorderSide.none,
                                                          right: col < 8
                                                              ? BorderSide(color: Colors.white)
                                                              : BorderSide.none,
                                                        ),
                                                      ), 
                                                      child: ShadButton(
                                                        hoverBackgroundColor: Colors.transparent,
                                                        foregroundColor: Colors.transparent,
                                                        backgroundColor: Colors.transparent,
                                                        padding: EdgeInsets.zero,
                                                        onTapUp: (value) {
                                                          if(mixMap["($col,${row + 1})"] ?? false){
                                                            appModel.setMatrixMixMapping(col.toString(), (row+1).toString(), false);
                                                          }else{
                                                            bool usedOutput = checkOutput(row + 1);
                                                            if(usedOutput){
                                                              appModel.setMatrixMixMapping(col.toString(), (row+1).toString(), true);
                                                            }
                                                          }
                                                        },  
                                                        child: Center(
                                                          child: Text(
                                                            mixMap["($col,${row + 1})"] ?? false ? "X" : "", 
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                        ),
                                                      )
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}


