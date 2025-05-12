import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/models/application_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class InputChannelsPreferencesPage extends StatefulWidget{
  const InputChannelsPreferencesPage({super.key});

  @override
  State<InputChannelsPreferencesPage> createState() => InputChannelsPreferencesPageState();
}

class InputChannelsPreferencesPageState extends State<InputChannelsPreferencesPage>{

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
                  return Column(
                    spacing: 50,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          Map<String, String> labels = appModel.inputLabels;
                          Map<String, bool> visibility = appModel.inputVisibility;
                      
                          int rowNumber = (appModel.inputLabels.length/2).toInt();
                          Widget content = Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            spacing: 30,
                            children: List.generate(rowNumber, (rowIndex) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children:[
                                  Row(children: [
                                    ShadButton(
                                      backgroundColor: Colors.transparent,
                                      width: 35,
                                      height: 35,
                                      padding: EdgeInsets.zero,
                                      decoration: const ShadDecoration(
                                        secondaryBorder: ShadBorder.none,
                                        secondaryFocusedBorder: ShadBorder.none,
                                      ),
                                      icon: Icon(visibility["${rowIndex * 2 + 1}"] ?? true ? LucideIcons.eye : LucideIcons.eyeOff, size: 20,),
                                      foregroundColor: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          appModel.toggleChannelVisibility(rowIndex * 2 + 1, "input", !(visibility["${rowIndex * 2 + 1}"] ?? true));
                                        });
                                      },
                                      hoverBackgroundColor: Colors.transparent,
                                      hoverForegroundColor: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      height: 50,
                                      child: ShadInput(
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                        padding: EdgeInsets.zero,
                                        onChanged: (value) => appModel.changeChannelLabels("input", "${rowIndex * 2 + 1}", value),
                                        initialValue: labels["${rowIndex * 2 + 1}"],
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
                                    ),
                                  ],),
                                  Row(children: [
                                    SizedBox(
                                      width: 100,
                                      height: 50,
                                      child: ShadInput(
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                        padding: EdgeInsets.zero,
                                        onChanged: (value) => appModel.changeChannelLabels("input", "${rowIndex * 2 + 2}", value),
                                        initialValue: labels["${rowIndex * 2 + 2}"],
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
                                    ),
                                    ShadButton(
                                      backgroundColor: Colors.transparent,
                                      width: 35,
                                      height: 35,
                                      padding: EdgeInsets.zero,
                                      decoration: const ShadDecoration(
                                        secondaryBorder: ShadBorder.none,
                                        secondaryFocusedBorder: ShadBorder.none,
                                      ),
                                      icon: Icon(visibility["${rowIndex * 2 + 2}"] ?? true ? LucideIcons.eye : LucideIcons.eyeOff, size: 20,),
                                      foregroundColor: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          appModel.toggleChannelVisibility(rowIndex * 2 + 2, "input", !(visibility["${rowIndex * 2 + 2}"] ?? true));
                                        });
                                      },
                                      hoverBackgroundColor: Colors.transparent,
                                      hoverForegroundColor: Colors.white,
                                    ),
                                  ],),
                                ]
                              );
                            }),
                          );
                          return Center(child: SingleChildScrollView(child: content));
                        },
                      ),
                    ],
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


class OutputChannelsPreferencesPage extends StatefulWidget{
  const OutputChannelsPreferencesPage({super.key});

  @override
  State<OutputChannelsPreferencesPage> createState() => OutputChannelsPreferencesPageState();
}

class OutputChannelsPreferencesPageState extends State<OutputChannelsPreferencesPage>{

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
                  return Column(
                    spacing: 50,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          Map<String, String> labels = appModel.outputLabels;
                          Map<String, bool> visibility = appModel.outputVisibility;
                      
                          int rowNumber = (appModel.outputLabels.length/2 - 1).toInt();
                          Widget content = Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            spacing: 30,
                            children: List.generate(rowNumber, (rowIndex) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children:[
                                  Row(children: [
                                    ShadButton(
                                      backgroundColor: Colors.transparent,
                                      width: 35,
                                      height: 35,
                                      padding: EdgeInsets.zero,
                                      decoration: const ShadDecoration(
                                        secondaryBorder: ShadBorder.none,
                                        secondaryFocusedBorder: ShadBorder.none,
                                      ),
                                      icon: Icon(visibility["${rowIndex * 2 + 3}"] ?? true ? LucideIcons.eye : LucideIcons.eyeOff, size: 20,),
                                      foregroundColor: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          appModel.toggleChannelVisibility(rowIndex * 2 + 3, "output", !(visibility["${rowIndex * 2 + 3}"] ?? true));
                                        });
                                      },
                                      hoverBackgroundColor: Colors.transparent,
                                      hoverForegroundColor: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      height: 50,
                                      child: ShadInput(
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                        padding: EdgeInsets.zero,
                                        onChanged: (value) => appModel.changeChannelLabels("output", "${rowIndex * 2 + 3}", value),
                                        initialValue: labels["${rowIndex * 2 + 3}"],
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
                                    ),
                                  ],),
                                  Row(children: [
                                    SizedBox(
                                      width: 100,
                                      height: 50,
                                      child: ShadInput(
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                        padding: EdgeInsets.zero,
                                        onChanged: (value) => appModel.changeChannelLabels("output", "${rowIndex * 2 + 4}", value),
                                        initialValue: labels["${rowIndex * 2 + 4}"],
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
                                    ),
                                    ShadButton(
                                      backgroundColor: Colors.transparent,
                                      width: 35,
                                      height: 35,
                                      padding: EdgeInsets.zero,
                                      decoration: const ShadDecoration(
                                        secondaryBorder: ShadBorder.none,
                                        secondaryFocusedBorder: ShadBorder.none,
                                      ),
                                      icon: Icon(visibility["${rowIndex * 2 + 4}"] ?? true ? LucideIcons.eye : LucideIcons.eyeOff, size: 20,),
                                      foregroundColor: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          appModel.toggleChannelVisibility(rowIndex * 2 + 4, "output", !(visibility["${rowIndex * 2 + 4}"] ?? true));
                                        });
                                      },
                                      hoverBackgroundColor: Colors.transparent,
                                      hoverForegroundColor: Colors.white,
                                    ),
                                  ],),
                                ]
                              );
                            }),
                          );
                          return Center(child: SingleChildScrollView(child: content));
                        },
                      ),
                    ],
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
