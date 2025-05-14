import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/components/homeScreen/home_screen_components.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/application_model.dart';

class AudioPage extends StatefulWidget{
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => AudioPageState();
}

class AudioPageState extends State<AudioPage> {

  final ScrollController _scrollInputController = ScrollController();
  final ScrollController _scrollOutputController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    final dimensions = Dimensions();

    return SafeArea(
      child: Consumer<ApplicationModel>(
        builder: (context, appModel, child){

          Widget extendedWidget = Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 30,
                    children: [
                      PresetButton(height: 50, fontSize: 22, previousPage: 1, text: appModel.matrixPresetLabels["${appModel.currentMatrixPreset}"] ?? "Preset"),
                      Container(
                        width: 150,
                        height: 600,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 80),
                        decoration: BoxDecoration(
                          color: colors.primaryColor,
                          border: Border.all(
                            width: 2,
                            color: colors.selectionColor
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ChannelSlider(
                          isMaster: true,
                          width: 90,
                          index: 1,
                          direction: 1,
                          bidirectional: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top:20, left: 25, right: 40, bottom: 10),
                        child: Center(
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: 450,
                              maxWidth: 1400,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primaryColor,
                              border: Border.all(width: 2, color: colors.selectionColor),
                              borderRadius: BorderRadius.circular(50)
                            ),
                            padding: EdgeInsets.only(top: 40, bottom: 20, left: 40, right: 40),
                            child: Scrollbar(
                              controller: _scrollInputController,
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                controller: _scrollInputController,
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: List.generate(appModel.inputVolumes.length, (index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: ChannelSlider(
                                          width: 90,
                                          index: (index + 1),
                                          bidirectional: false,
                                          direction: 0,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top:20, left: 25, right: 40, bottom: 10),
                        child: Center(
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: 450,
                              maxWidth: 1400,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primaryColor,
                              border: Border.all(width: 2, color: colors.selectionColor),
                              borderRadius: BorderRadius.circular(50)
                            ),
                            padding: EdgeInsets.only(top: 40, bottom: 20, left: 40, right: 40),
                            child: Scrollbar(
                              controller: _scrollOutputController,
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                controller: _scrollOutputController,
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: List.generate(appModel.outputVolumes.length, (index) {
                                      if(index != 0 && index != 1){
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: ChannelSlider(
                                            width: 90,
                                            index: (index + 1),
                                            bidirectional: false,
                                            direction: 1,
                                          ),
                                        );
                                      }else{
                                        return SizedBox.shrink();
                                      }
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ],
          );

          Widget reducedWidget = Center(child: Text("RIDOTTO"),);

          return appModel.matrixConnected
          ? dimensions.screenHeight >= 900 && dimensions.screenWidth >= 800
            ?extendedWidget
            :reducedWidget
          : Center(
            child: Text("NO MATRIX CONNECTED"),
          );
        },
      )
    );
  }
}
