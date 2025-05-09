import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/components/matrixScreen/matrix_screen_components.dart';
import 'package:rem_app/components/scrolling_label.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/application_model.dart';
import 'package:rem_app/models/common_interface.dart';
import 'package:rem_app/pages/homePages/preset_page.dart';
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


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageIndex == 0) {
        preferencesScreenController.animateToPage(
          0,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      } else {
        preferencesScreenController.animateToPage(
          1,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    });

    final colors = AppColors();
    final dimensions = Dimensions();

    return SafeArea(
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
          actions: [
            SizedBox(width: 60,),
            ActionButton(iconData: PhosphorIcons.check(), action: ()=>{},),
            SizedBox(width: dimensions.isPc ? 50 : 20),
          ],
          centerTitle: true,
          title: Center(child: Text("PREFERENCES", style: TextStyle(color: Colors.white, fontSize: dimensions.isPc ? 20 : 15),),)
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 0, left: 30, bottom: 30, right: 30),
          child: Center(
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
                  Row(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectionButton(text: "Preset\nLabels", index: 0, pageIndex: pageIndex, action: () => pageIndex = 0),
                      SelectionButton(text: "Channels", index: 1, pageIndex: pageIndex, action: () => pageIndex = 1)
                    ],
                  ),
                  Center(
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: preferencesScreenController,
                      children: [
                        PresetPreferencesPage(),
                        ChannelsPreferencesPage(),
                      ]
                    ),
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}


class SelectionButton extends StatefulWidget{
  const SelectionButton({super.key, required this.text, required this.index, required this.pageIndex, required this.action});

  final String text;
  final int index;
  final int pageIndex;
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
        Navigator.pop(context)
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
          height: 60,
          decoration: ShadDecoration(
            border: ShadBorder.all(
              color: widget.pageIndex == widget.index ? colors.selectionColor : Colors.white
            )
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isHovered ? (widget.pageIndex == widget.index ? colors.selectionColor : Colors.white) : Colors.transparent,
                  width: 1,
                ),
              ),
            ),
            padding: EdgeInsets.only(bottom: 1),
            child: Text(widget.text, style: TextStyle(color: widget.pageIndex == widget.index ? colors.selectionColor : Colors.white, fontSize: dimensions.isPc ? 22 : 18),),
          ), 
        )
      )
    );
  }
}