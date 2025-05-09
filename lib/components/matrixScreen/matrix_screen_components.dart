import 'package:flutter/material.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/dimensions.dart';

final dimensions = Dimensions();
final colors = AppColors();

class ActionButton extends StatefulWidget{
  const ActionButton({super.key, required this.iconData, required this.action});

  final IconData iconData;
  final VoidCallback action;

  @override
  ActionButtonState createState() => ActionButtonState();
}

class ActionButtonState extends State<ActionButton>{
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
      onTapUp: (details){
        if(!dimensions.isDesktop){
          setState(() {
            isHovered = false;
          });
        }
        widget.action();
      },
      child: MouseRegion(
        onEnter: (event) => {
          setState(() => isHovered = true),
        },
        onExit: (event) => {
          setState(() => isHovered = false),
        },
        cursor: SystemMouseCursors.click,
        child: Icon(widget.iconData, size: dimensions.isPc ? 40 : 26, color: isHovered ? colors.selectionColor : Colors.white,),
      ),
    );
  }
}

