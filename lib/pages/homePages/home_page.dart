import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/components/homeScreen/home_screen_components.dart';
import 'package:rem_app/components/scrolling_label.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/application_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
  final colors = AppColors();
  final dimensions = Dimensions();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ApplicationModel>(
        builder: (context, appModel, child){
          return appModel.matrixConnected
          ? Center(
            child: SizedBox.expand  (
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(dimensions.screenHeight >= 600)
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PresetButton(height: 50, fontSize: dimensions.isPc ? 22 : 18, previousPage: 0, text: appModel.matrixPresetLabels["${appModel.currentMatrixPreset}"] ?? "Preset"),
                          MatrixMapButton(height: 50, fontSize: dimensions.isPc ? 22 : 18, previousPage: 0, text: "Matrix Map")
                        ],
                      )
                    ),
                  HomePageChannelPreview(isInput: true,),
                  HomePageChannelPreview(isInput: false,),
                  if(dimensions.screenHeight >= 600)
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 20),
                      child: MuteAllButton(height: 50, fontSize: dimensions.isPc ? 22 : 18, action: appModel.toggleAllMuteChannel,)
                    ),
                  if(dimensions.screenHeight < 600)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        PresetButton(height: 30, fontSize: 13, previousPage: 0, text: appModel.matrixPresetLabels["${appModel.currentMatrixPreset}"] ?? "Preset"),
                        MatrixMapButton(height: 30, fontSize: 13, previousPage: 0, text: "Matrix Map"),
                        MuteAllButton(height: 30, fontSize: 13, action: appModel.toggleAllMuteChannel,),
                      ],
                    )
                ],
              ),
            ),
          )
          : Center(
            child: Text("NO MATRIX CONNECTED"),
          );
        },
      )
    );
  }
}

class MuteAllButton extends StatefulWidget {
  const MuteAllButton({super.key, required this.height, required this.fontSize, required this.action});

  final double height;
  final double fontSize;
  final Function action;

  @override
  MuteAllButtonState createState() => MuteAllButtonState();
}

class MuteAllButtonState extends State<MuteAllButton>{
  final colors = AppColors();

  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => {
        setState(() {
          isHovered = true;
        })
      },
      onTapCancel: () => {
        setState(() {
          isHovered = false;
        }),
      },
      onTapUp: (details) => {
        setState(() {
          isHovered = false;
        }),
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHovered = false;
          });
        },
        child: ShadButton.outline(
          onTapUp: (value) => widget.action(),
          hoverBackgroundColor: Colors.black,
          height: widget.height,
          width: 120,
          decoration: ShadDecoration(
            border: ShadBorder.all(color: colors.mutedChannel)
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isHovered ? colors.mutedChannel : Colors.transparent,
                  width: 1,
                ),
              ),
            ),
            padding: EdgeInsets.only(bottom: 1),
            child: Text("Mute All", style: TextStyle(color: colors.mutedChannel, fontSize: widget.fontSize))
          ),
        )
      )
    );
  }
}


class HomePageChannelPreview extends StatefulWidget{
  const HomePageChannelPreview({super.key, required this.isInput});

  final bool isInput;

  @override
  HomePageChannelPreviewState createState() => HomePageChannelPreviewState();
}

class HomePageChannelPreviewState extends State<HomePageChannelPreview> {
  final colors = AppColors();
  final dimensions = Dimensions();

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationModel>(
      builder: (context, appModel, child){
        return Expanded(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: dimensions.screenHeight < 600 ? 1 : dimensions.screenHeight <= 800 ? 10 : 20, horizontal: 30),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 1200
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: dimensions.isDesktop ? colors.selectionColor : colors.primaryColor, width: 2),
                      color: colors.primaryColor
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(15)
                              ),
                              alignment: Alignment.center,
                              width: dimensions.isPc ? 100 : 80,
                              height: 30,
                              child: Text(widget.isInput ? "Input" : "Output", style: TextStyle(fontSize: dimensions.isPc ? 20 : 16),)
                            )
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                Map<String, bool> visibility = widget.isInput ? appModel.inputVisibility : appModel.outputVisibility;
                                Map<String, bool> mute = widget.isInput ? appModel.inputMute : appModel.outputMute;
                                Map<String, String> labels = widget.isInput ? appModel.inputLabels : appModel.outputLabels;
                                int rowNumber = (appModel.inputVisibility.length/4).toInt();
                                Widget content = Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  spacing: 30,
                                  children: List.generate(rowNumber, (rowIndex) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: List.generate(4, (colIndex) {
                                        return ShadButton.outline(
                                          enabled: rowIndex == 0 && colIndex == 1 && !widget.isInput ? false : visibility[(rowIndex * 4 + colIndex + 1).toString()] ?? true,
                                          onTapUp: (_){
                                            appModel.toggleMuteChannel(rowIndex * 4 + colIndex + 1, widget.isInput ? "input" : "output", !(mute[(rowIndex * 4 + colIndex + 1).toString()] ?? false));
                                          },
                                          hoverBackgroundColor: Colors.transparent,
                                          width: 60,
                                          height: 50,
                                          padding: EdgeInsets.all(0),
                                          decoration: ShadDecoration(
                                            border: ShadBorder.all(
                                              color: (mute["${rowIndex * 4 + colIndex + 1}"] ?? true) 
                                                ? colors.mutedChannel 
                                                : colors.unmutedChannel, 
                                              radius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: ScrollingLabel(
                                            width: 50,
                                            maxCharCount: 4,
                                            text: rowIndex == 0 && (colIndex == 0 || colIndex == 1) && !widget.isInput ? "Master" : labels["${rowIndex * 4 + colIndex + 1}"].toString(),
                                            color: (mute["${rowIndex * 4 + colIndex + 1}"] ?? true)
                                                ? colors.mutedChannel
                                                : colors.unmutedChannel,
                                          ),
                                        );
                                      }),
                                    );
                                  }),
                                );
                                return Center(child: SingleChildScrollView(child: content));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
