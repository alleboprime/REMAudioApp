import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rem_app/components/matrixScreen/%20matrix_screen_components.dart';

class MatrixScreen extends StatefulWidget {
  const MatrixScreen({super.key});

  @override
  State<MatrixScreen> createState() => MatrixScreenState();
}

class MatrixScreenState extends State<MatrixScreen> {
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
          actions: [],
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: dimensions.isPc ? Size(460, 460) : Size(380, 380),
                painter: ConnectionBackground(),
              ),
              NewConnectionButton()
            ]
          ),
        ),
      ),
    );
  }
}

class ConnectionBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    final maxRadius = size.width / 2; 
    final step = 20; 

    for (int i = 1; i <= 4; i++) {
      double r = maxRadius - (i * step);
      double opacity = 1 - (4-i+1) * 0.2;
      final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Color.fromRGBO(0, 122, 255, opacity);
      
      canvas.drawCircle(center, r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}