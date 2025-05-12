import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/models/application_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MatrixPresetPreferencesPage extends StatefulWidget{
  const MatrixPresetPreferencesPage({super.key, required this.changedPresetLabels});

  final Map<String, String> changedPresetLabels;

  @override
  State<MatrixPresetPreferencesPage> createState() => MatrixPresetPreferencesPageState();
}

class MatrixPresetPreferencesPageState extends State<MatrixPresetPreferencesPage>{

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<ApplicationModel>(
                builder: (context, appModel, child) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      Map<String, String> labels = appModel.matrixPresetLabels;
                  
                      int rowNumber = (appModel.matrixPresetLabels.length/2).toInt();
                      Widget content = Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        spacing: 30,
                        children: List.generate(rowNumber, (rowIndex) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(2, (colIndex) {
                              return SizedBox(
                                width: 120,
                                height: 50,
                                child: ShadInput(
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                  padding: EdgeInsets.zero,
                                  onChanged: (value) => widget.changedPresetLabels["${rowIndex * 2 + colIndex + 1}"] = value,
                                  placeholderAlignment: Alignment.center,
                                  initialValue: labels["${rowIndex * 2 + colIndex + 1}"],
                                  decoration: ShadDecoration(                                    
                                    secondaryBorder: ShadBorder.all(
                                      color: Colors.white,
                                      width: 1,
                                      radius: BorderRadius.circular(10),
                                    ),
                                    secondaryFocusedBorder: ShadBorder.all(
                                      color: Colors.white,
                                      width: 1,
                                      radius: BorderRadius.circular(10),
                                    ),
                                    disableSecondaryBorder: false,
                                  ),
                                ),
                              );
                            }),
                          );
                        }),
                      );
                      return Center(child: SingleChildScrollView(child: content));
                    },
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CameraPresetPreferencesPage extends StatefulWidget{
  const CameraPresetPreferencesPage({super.key, required this.changedPresetLabels});

  final Map<String, String> changedPresetLabels;

  @override
  State<CameraPresetPreferencesPage> createState() => CameraPresetPreferencesPageState();
}

class CameraPresetPreferencesPageState extends State<CameraPresetPreferencesPage>{

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<ApplicationModel>(
                builder: (context, appModel, child) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      Map<String, String> labels = appModel.cameraPresetLabels;
                  
                      int rowNumber = (appModel.cameraPresetLabels.length/2).toInt();
                      Widget content = Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        spacing: 30,
                        children: List.generate(rowNumber, (rowIndex) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(2, (colIndex) {
                              return SizedBox(
                                width: 120,
                                height: 50,
                                child: ShadInput(
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                  padding: EdgeInsets.zero,
                                  onChanged: (value) => widget.changedPresetLabels["${rowIndex * 2 + colIndex}"] = value,
                                  placeholderAlignment: Alignment.center,
                                  initialValue: labels["${rowIndex * 2 + colIndex}"],
                                  decoration: ShadDecoration(                                    
                                    secondaryBorder: ShadBorder.all(
                                      color: Colors.white,
                                      width: 1,
                                      radius: BorderRadius.circular(10),
                                    ),
                                    secondaryFocusedBorder: ShadBorder.all(
                                      color: Colors.white,
                                      width: 1,
                                      radius: BorderRadius.circular(10),
                                    ),
                                    disableSecondaryBorder: false,
                                  ),
                                ),
                              );
                            }),
                          );
                        }),
                      );
                      return Center(child: SingleChildScrollView(child: content));
                    },
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}