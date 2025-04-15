import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/dimensions.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

final dimensions = Dimensions();
final colors = AppColors();

class NewConnectionButton extends StatefulWidget{
  const NewConnectionButton({super.key, this.authorized = true});

  final bool authorized;

  @override
  // ignore: library_private_types_in_public_api
  NewConnectionButtonState createState() => NewConnectionButtonState();
}

class NewConnectionButtonState extends State<NewConnectionButton>{
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
        hoverBackgroundColor: colors.primaryColor,
        width: dimensions.isPc ? 230 : 160,
        height: dimensions.isPc ? 230 : 160,
        decoration: ShadDecoration(
          border: ShadBorder.all(radius: BorderRadius.circular(100), color: colors.selectionColor, style: BorderStyle.solid, width: 2)
        ),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("New Connection", 
              style: TextStyle(
                fontSize: dimensions.isPc ? 20 : 16,
                color: colors.selectionColor, 
                decoration: isHovered ? TextDecoration.underline : TextDecoration.none,
                decorationColor: colors.selectionColor,
                decorationThickness: 2
              ),
            ),
            SizedBox(height: 10,),
            Icon(PhosphorIcons.link(), color: colors.selectionColor, size: dimensions.isPc ? 30 : 25,)
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatefulWidget{
  const ActionButton({super.key, required this.iconData, required this.action});

  final IconData iconData;
  final VoidCallback action;

  @override
  // ignore: library_private_types_in_public_api
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
        child: Icon(widget.iconData, size: dimensions.isPc ? 40 : 30, color: isHovered ? colors.selectionColor : Colors.white,),
      ),
    );
  }
}

