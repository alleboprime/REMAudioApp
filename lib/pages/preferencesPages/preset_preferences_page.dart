import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/components/scrolling_label.dart';
import 'package:rem_app/models/application_model.dart';
import 'package:rem_app/models/common_interface.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PresetPreferencesPage extends StatefulWidget{
  const PresetPreferencesPage({super.key});

  @override
  State<PresetPreferencesPage> createState() => PresetPreferencesPageState();
}

class PresetPreferencesPageState extends State<PresetPreferencesPage>{

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
              Consumer2<ApplicationModel, CommonInterface>(
                builder: (context, appModel, commonInterface, child) {
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
                                  onChanged: (value) => print(value),
                                  placeholderAlignment: Alignment.center,
                                  placeholder: ScrollingLabel(
                                    maxCharCount: 10,
                                    text: labels["${rowIndex * 2 + colIndex + 1}"].toString(),
                                    color: Colors.white,
                                  ),
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