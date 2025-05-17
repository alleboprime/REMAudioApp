import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/components/matrixScreen/matrix_screen_components.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/pages/preferencesPages/channels_preferences_page.dart';
import 'package:rem_app/pages/preferencesPages/preset_preferences_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PreferencesScreen extends StatefulWidget{
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => PreferencesScreenState();
}

class PreferencesScreenState extends State<PreferencesScreen>{

  PageController preferencesScreenController = PageController(initialPage: 0);  

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;
  set pageIndex(int value){
    setState(() {
      _pageIndex = value;
    });
  }

  int _selection = 0;
  int get selection => _selection;
  set selection(int value){
    setState(() {
      _selection = value;
      pageIndex = selection + subSelection;
    });
  }

  int _subSelection = 0;
  int get subSelection => _subSelection;
  set subSelection(int value){
    setState(() {
      _subSelection = value;
      pageIndex = selection + subSelection;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageIndex == 0) {
        preferencesScreenController.animateToPage(
          0,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      } else if(pageIndex == 1) {
        preferencesScreenController.animateToPage(
          1,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }else if(pageIndex == 2) {
        preferencesScreenController.animateToPage(
          2,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }else {
        preferencesScreenController.animateToPage(
          3,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    });

    final colors = AppColors();
    final dimensions = Dimensions();

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            toolbarHeight: 100,
            leadingWidth: dimensions.isPc ? 150 : 90,
            backgroundColor: Colors.black,
            surfaceTintColor: Colors.black,
            foregroundColor: Colors.transparent,
            leading: Row(
              children: [
                SizedBox(width: dimensions.isPc ? 50 : 20),
                ActionButton(iconData: PhosphorIcons.arrowLeft(), action: () => Navigator.pop(context),),
              ],
            ),
            centerTitle: true,
            title: Center(child: Text("PREFERENCES", style: TextStyle(color: Colors.white, fontSize: dimensions.isPc ? 20 : 15),),),
            actions: [
              SizedBox(width: dimensions.isPc ? 150 : 100,)
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 0, left: 30, bottom: 30, right: 30),
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 620,
                  maxHeight: 700,
                ),
                child: Column(
                  spacing: 20,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SelectionButton(text: "Preset\nLabels", index: 0, selection: selection, action: () => selection = 0),
                        SelectionButton(text: "Channels", index: 2, selection: selection, action: () => selection = 2)
                      ],
                    ),
                    Row( 
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShadButton.outline(
                          hoverBackgroundColor: Colors.transparent,
                          width: selection == 0 ? 70 : 40,
                          height: 30,
                          padding: EdgeInsets.zero,
                          decoration: ShadDecoration(
                            border: ShadBorder.all(color: subSelection == 0 ? colors.selectionColor : Colors.white),
                            disableSecondaryBorder: true,
                          ),
                          onTapUp: (value) {
                            setState(() {
                              subSelection = 0;
                            });
                          },
                          child: Text(selection == 0 ? "Matrix" : "IN", style: TextStyle(color: subSelection == 0 ? colors.selectionColor : Colors.white),),
                        ),
                        ShadButton.outline(
                          hoverBackgroundColor: Colors.transparent,
                          width: selection == 0 ? 70 : 40,
                          height: 30,
                          padding: EdgeInsets.zero,
                          decoration: ShadDecoration(
                            border: ShadBorder.all(color: subSelection == 1 ? colors.selectionColor : Colors.white),
                            disableSecondaryBorder: true,
                          ),
                          onTapUp: (value) {
                            setState(() {
                              subSelection = 1;
                            });
                          },
                          child: Text(selection == 0 ? "Camera" : "OUT", style: TextStyle(color: subSelection == 1 ? colors.selectionColor : Colors.white),),
                        )
                      ],
                    ),
                    Expanded(
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
                        child: Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: PageView(
                                  physics: NeverScrollableScrollPhysics(),
                                  controller: preferencesScreenController,
                                  children: [
                                    MatrixPresetPreferencesPage(),
                                    CameraPresetPreferencesPage(),
                                    InputChannelsPreferencesPage(),
                                    OutputChannelsPreferencesPage(),
                                  ]
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
          ),
        ),
      ),
    );
  }
}


class SelectionButton extends StatefulWidget{
  const SelectionButton({super.key, required this.text, required this.index, required this.selection, required this.action});

  final String text;
  final int index;
  final int selection;
  final Function action;

  @override
  State<SelectionButton> createState() => SelectionButtonState();
}

class SelectionButtonState extends State<SelectionButton> {

  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(); 
    final dimensions = Dimensions();

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
          hoverBackgroundColor: Colors.transparent,
          onTapUp: (value) => widget.action(),
          padding: EdgeInsets.all(0),
          width: 120,
          height: dimensions.isPc ? 60 : 45,
          decoration: ShadDecoration(
            border: ShadBorder.all(
              color: widget.selection == widget.index ? colors.selectionColor : Colors.white
            )
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isHovered ? (widget.selection == widget.index ? colors.selectionColor : Colors.white) : Colors.transparent,
                  width: 1,
                ),
              ),
            ),
            padding: EdgeInsets.only(bottom: 1),
            child: Text(widget.text, style: TextStyle(color: widget.selection == widget.index ? colors.selectionColor : Colors.white, fontSize: dimensions.isPc ? 22 : 18),),
          ), 
        )
      )
    );
  }
}