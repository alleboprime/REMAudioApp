import 'package:flutter/material.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/dimensions.dart';

final dimensions = Dimensions();
final colors = AppColors();

class ActionButton extends StatefulWidget{
  const ActionButton({super.key, required this.iconData, required this.primaryAction, this.secondaryAction, this.isZoom = false});

  final IconData iconData;
  final VoidCallback primaryAction;
  final VoidCallback? secondaryAction;

  final bool isZoom;

  @override
  ActionButtonState createState() => ActionButtonState();
}

class ActionButtonState extends State<ActionButton>{
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details){
        setState(() {
          isHovered = true;
        });
        if(widget.isZoom)widget.primaryAction();
      },
      onTapCancel: (){
        setState(() {
          isHovered = false;
        });
        if(widget.isZoom)widget.secondaryAction!();
      },
      onTapUp: (details){
        if(!dimensions.isDesktop){
          setState(() {
            isHovered = false;
          });
        }
        if(widget.isZoom){
          widget.secondaryAction!();
        }else{
          widget.primaryAction();
        }
      },
      onDoubleTap: (){
        widget.secondaryAction!();
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

