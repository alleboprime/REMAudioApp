import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/components/scrolling_label.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/application_model.dart';
import 'package:rem_app/models/common_interface.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PresetPage extends StatefulWidget{
  const PresetPage({super.key});

  @override
  PresetPageState createState() => PresetPageState();
}

class PresetPageState extends State<PresetPage>{
  final dimensions = Dimensions();
  final colors = AppColors();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Consumer2<ApplicationModel, CommonInterface>(
          builder: (context, appModel, commonInterface, child) {
            return Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 600,
                  maxHeight: 600,
                ),
                decoration: BoxDecoration(
                  color: dimensions.isDesktop ? colors.primaryColor : colors.primaryColor,
                  border: Border.all(color: dimensions.isDesktop ? colors.selectionColor : Colors.transparent, width: 2),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Center(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              Map<String, String> labels = appModel.matrixPresetLabels;
                              int currentPreset = appModel.currentMatrixPreset;

                              int rowNumber = (appModel.matrixPresetLabels.length/2).toInt();
                              Widget content = Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                spacing: 30,
                                children: List.generate(rowNumber, (rowIndex) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: List.generate(2, (colIndex) {
                                      return ShadButton.outline(
                                        onTapUp: (_) async {
                                          commonInterface.isLoading = true;
                                          bool result = await appModel.setMatrixPreset(rowIndex * 2 + colIndex + 1);
                                          commonInterface.isLoading = false;
                                          if(!result){
                                            commonInterface.failingReason = "Failed setting preset";
                                          }
                                          if(context.mounted)Navigator.pushNamed(context, "/home");
                                        },
                                        hoverBackgroundColor: Colors.transparent,
                                        width: 120,
                                        height: 50,
                                        padding: EdgeInsets.all(0),
                                        decoration: ShadDecoration(
                                          border: ShadBorder.all(
                                            color: (currentPreset == (rowIndex * 2 + colIndex + 1)) 
                                              ? colors.selectionColor 
                                              : Colors.white, 
                                            radius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: ScrollingLabel(
                                          width: 100,
                                          maxCharCount: 10,
                                          text: labels["${rowIndex * 2 + colIndex + 1}"].toString(),
                                          color: (currentPreset == (rowIndex * 2 + colIndex + 1))
                                              ? colors.selectionColor
                                              : Colors.white,
                                        ),
                                      );
                                    }),
                                  );
                                }),
                              );
                              return Center(child: SingleChildScrollView(child: content));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            );
          }
        ),
      ),
    );
  }
}