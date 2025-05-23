import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/components/scrolling_label.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/application_model.dart';
import 'package:rem_app/models/home_nav_bar_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SettingsTile extends StatefulWidget{
  const SettingsTile({super.key, required this.title, required this.iconOrigin, required this.action, this.color = Colors.white});

  final String title;
  final IconData iconOrigin;
  final Color color;
  final ValueChanged action;

  @override
  SettingsTileState createState() => SettingsTileState();
}

class SettingsTileState extends State<SettingsTile>{
  final dimensions = Dimensions();
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
          onTapUp: widget.action,
          hoverBackgroundColor: colors.primaryColor,
          height: dimensions.isPc ? 60 : 50,
          padding: EdgeInsets.all(10),
          mainAxisAlignment: MainAxisAlignment.start,
          decoration: ShadDecoration(border: ShadBorder.all(width: 0)),
          icon: Icon(widget.iconOrigin, color: widget.color, size: dimensions.isPc ? 30 : 18,),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isHovered ? widget.color : Colors.transparent,
                  width: 1,
                ),
              ),
            ),
            padding: EdgeInsets.only(bottom: 1),
            child: Text(
              widget.title, 
              style: TextStyle(
                color: widget.color, 
                fontSize: dimensions.isPc ? 22 : 16,
              ),
            )
          ),
        ),
      ),
    );
  }
}


class PresetButton extends StatefulWidget{
  const PresetButton({super.key, required this.height, required this.fontSize, required this.text, required this.previousPage, required this.matrixPreset});

  final double height;
  final double fontSize;
  final String text;
  final int previousPage;
  final bool matrixPreset;

  @override
  PresetButtonState createState() => PresetButtonState();
}

class PresetButtonState extends State<PresetButton>{
  final dimensions = Dimensions();
  final colors = AppColors();

  bool isHovered = false;

  @override
  Widget build (BuildContext context){
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
        child: Consumer<HomeNavBarModel>(
          builder: (context, navBarModel, child){
            return ShadButton.outline(
              onTapUp: (value){
                navBarModel.previousPage = widget.previousPage;
                navBarModel.matrixPreset = widget.matrixPreset;
                navBarModel.selectedPage = 4;
              },
              hoverBackgroundColor: Colors.black,
              height: widget.height,
              width: 120,
              decoration: ShadDecoration(
                border: ShadBorder.all(color: colors.selectionColor)
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isHovered ? colors.selectionColor : Colors.transparent,
                      width: 1,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(bottom: 1),
                child: ScrollingLabel(text: widget.text, color: colors.selectionColor, maxCharCount: 7, fontSize : widget.fontSize, width: 80,)
              ),
            );
          },
        )
      ),
    );
  }
}


class MatrixMapButton extends StatefulWidget{
  const MatrixMapButton({super.key, required this.height, required this.fontSize, required this.text, required this.previousPage});

  final double height;
  final double fontSize;
  final String text;
  final int previousPage;

  @override
  MatrixMapButtonState createState() => MatrixMapButtonState();
}

class MatrixMapButtonState extends State<MatrixMapButton>{
  final dimensions = Dimensions();
  final colors = AppColors();

  bool isHovered = false;

  @override
  Widget build (BuildContext context){
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
        child: Consumer<HomeNavBarModel>(
          builder: (context, navBarModel, child){
            return ShadButton.outline(
              onTapUp: (value){
                navBarModel.previousPage = widget.previousPage;
                navBarModel.selectedPage = 5;
              },
              hoverBackgroundColor: Colors.black,
              height: widget.height,
              width: 120,
              decoration: ShadDecoration(
                border: ShadBorder.all(color: colors.selectionColor)
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isHovered ? colors.selectionColor : Colors.transparent,
                      width: 1,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(bottom: 1),
                child: ScrollingLabel(text: widget.text, color: colors.selectionColor, maxCharCount: 7, fontSize : widget.fontSize, width: 80,)
              ),
            );
          },
        )
      ),
    );
  }
}


class ChannelSlider extends StatefulWidget{
  const ChannelSlider({super.key, this.isMaster = false, this.direction = 0, this.width = 90, required this.index, this.bidirectional = true});

  final bool isMaster;
  final bool bidirectional;
  final int direction;
  final double width;

  final int index;

  @override
  State<ChannelSlider> createState() => ChannelSliderState();
}

class ChannelSliderState extends State<ChannelSlider>{

  final appModel = ApplicationModel();

  late int origin;
  late ShadSliderController sliderController;

  @override
  void initState() {
    super.initState();
    origin = widget.direction;
    sliderController = ShadSliderController(
      initialValue: widget.isMaster 
          ? appModel.outputVolumes["1"] ?? 0 
          : widget.direction == 0 
              ? appModel.inputVolumes[widget.index.toString()] ?? 0 
              : appModel.outputVolumes[widget.index.toString()] ?? 0
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return Consumer<ApplicationModel>(
      builder: (context, appModel, child) {
        sliderController.value = widget.isMaster ? appModel.outputVolumes["1"] ?? 0 : origin == 0 ? appModel.inputVolumes[widget.index.toString()] ?? 0 : appModel.outputVolumes[widget.index.toString()] ?? 0;
        
        Map<String, bool> mute = origin == 0 ? appModel.inputMute : appModel.outputMute;
        Map<String, bool> visibility = origin == 0 ? appModel.inputVisibility : appModel.outputVisibility;

        void toggleMuteChannel(int index, int direction, bool value){
          appModel.toggleMuteChannel(index, direction == 0 ? "input" : "output", value);
        }

        return SizedBox(
          width: widget.width,
          child: Center(
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.isMaster
                    ?appModel.outputVolumes["1"].toString()
                    :origin == 0 
                      ?appModel.inputVolumes[widget.index.toString()].toString()
                      :appModel.outputVolumes[widget.index.toString()].toString()
                ),
                Expanded(
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: ShadSlider(
                      enabled: visibility[widget.index.toString()] ?? true,
                      max: 15,
                      min: -60,
                      controller: sliderController,
                      divisions: 75,
                      onChangeStart: (value){
                        appModel.lastVolumeValue = value.round();
                        appModel.startEditingChannelSlider(origin == 0 ? "input" : "output", widget.index.toString());
                      },
                      onChanged: (value) => appModel.lastVolumeValue = value.round(),
                      onChangeEnd: (value){
                        appModel.lastVolumeValue = value.round();
                        appModel.stopEditingChannelSlider();
                      },
                    ),
                  ),
                ),               
                ScrollingLabel(
                  text: widget.isMaster ? "Master" : origin == 0 ? appModel.inputLabels[widget.index.toString()].toString() : appModel.outputLabels[widget.index.toString()].toString(), 
                  color: Colors.white, 
                  maxCharCount: 8, 
                  width: widget.width
                ),
                if(widget.bidirectional && !widget.isMaster)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShadButton.outline(
                        hoverBackgroundColor: Colors.transparent,
                        width: (widget.width - 4)/2,
                        height: 30,
                        padding: EdgeInsets.zero,
                        decoration: ShadDecoration(
                          border: ShadBorder.all(color: origin == 0 ? colors.selectionColor : Colors.white),
                          disableSecondaryBorder: true,
                        ),
                        onTapUp: (value) {
                          setState(() {
                            origin = 0;
                          });
                        },
                        child: Text("IN", style: TextStyle(color: origin == 0 ? colors.selectionColor : Colors.white, fontSize: widget.width < 90 ? 10 : 14),),
                      ),
                      ShadButton.outline(
                        hoverBackgroundColor: Colors.transparent,
                        width: (widget.width - 4)/2,
                        height: 30,
                        padding: EdgeInsets.zero,
                        decoration: ShadDecoration(
                          border: ShadBorder.all(color: origin == 1 ? colors.selectionColor : Colors.white),
                          disableSecondaryBorder: true,
                        ),
                        onTapUp: (value) {
                          setState(() {
                            origin = 1;
                          });
                        },
                        child: Text("OUT", style: TextStyle(color: origin == 1 ? colors.selectionColor : Colors.white, fontSize: widget.width < 90 ? 10 : 14),),
                      ),
                    ],
                  ),
                if(!widget.bidirectional && !widget.isMaster)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShadButton.outline(
                        hoverBackgroundColor: Colors.transparent,
                        width: (widget.width - 4)/2,
                        height: 30,
                        padding: EdgeInsets.zero,
                        decoration: ShadDecoration(
                          border: ShadBorder.all(color: origin == widget.direction ? colors.selectionColor : Colors.white),
                          disableSecondaryBorder: true,
                        ),
                        onTapUp: (value) {
                          setState(() {
                            origin = widget.direction;
                          });
                        },
                        child: Text(widget.direction == 0 ? "IN" : "OUT", style: TextStyle(color: origin == widget.direction ? colors.selectionColor : Colors.white, fontSize: widget.width < 90 ? 10 : 14),),
                      ),
                    ],
                  ),
                    
                ShadButton.outline(
                  enabled: visibility[widget.index.toString()] ?? true,
                  hoverBackgroundColor: Colors.transparent,
                  width: 82,
                  height: 30,
                  padding: EdgeInsets.zero,
                  decoration: ShadDecoration(
                    border: ShadBorder.all(color: (mute[widget.index.toString()] ?? false) ? colors.mutedChannel : colors.unmutedChannel),
                    disableSecondaryBorder: true,
                  ),
                  onTapUp: (value) {
                    toggleMuteChannel(widget.index, origin, !(mute[widget.index.toString()] ?? false));
                  },
                  child: Text((mute[widget.index.toString()] ?? false) ? "UNMUTE" : "MUTE", style: TextStyle(color: (mute[widget.index.toString()] ?? false) ? colors.mutedChannel : colors.unmutedChannel, fontSize: widget.width < 90 ? 10 : 14),),
                )
              ],
            ),
          )
        );
      }
    );
  }

}

