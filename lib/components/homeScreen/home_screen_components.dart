import 'package:flutter/material.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/dimensions.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SettingsTile extends StatefulWidget{
  const SettingsTile({super.key, required this.title, required this.iconOrigin, required this.action, this.color = Colors.white});

  final String title;
  final IconData iconOrigin;
  final Color color;
  final ValueChanged action;

  @override
  // ignore: library_private_types_in_public_api
  _SettingsTileState createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile>{
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