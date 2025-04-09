import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rem_app/components/matrixScreen/matrix_screen_components.dart';

class MatrixConnectionsScreen extends StatefulWidget{
  const MatrixConnectionsScreen({super.key});

  @override
  State<MatrixConnectionsScreen> createState() => MatrixConnectionsScreenState();
}

class MatrixConnectionsScreenState extends State<MatrixConnectionsScreen>{
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: GestureDetector(
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
              onEnter: (event) => {
                setState(() => isHovered = true),
              },
              onExit: (event) => {
                setState(() => isHovered = false),
              },
              cursor: SystemMouseCursors.click,
              child: Icon(PhosphorIcons.arrowLeft(), size: dimensions.isPc ? 40 : 30, color: isHovered ? colors.selectionColor : Colors.white,),
            ),
          ),
          leadingWidth: 100,
          toolbarHeight: 100,
          backgroundColor: Colors.black,
        ),
        body: Center(child: Text("connections"),),
      ),
    );
  }
}