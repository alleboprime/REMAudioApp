import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/components/matrixScreen/matrix_screen_components.dart';
import 'package:rem_app/models/matrix_model.dart';
import 'package:rem_app/models/user_model.dart';

class NewMatrixSessionScreen extends StatefulWidget {
  const NewMatrixSessionScreen({super.key});

  @override
  State<NewMatrixSessionScreen> createState() => NewMatrixSessionScreenState();
}

class NewMatrixSessionScreenState extends State<NewMatrixSessionScreen> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leadingWidth: 100,
          toolbarHeight: 100,
          backgroundColor: Colors.transparent,
          leading: ActionButton(iconData: PhosphorIcons.arrowLeft(), action: () => Navigator.pop(context),),
        ),
        body: Consumer2<UserModel, MatrixModel>(
          builder: (context, userModel, matrixModel, child) {
            return userModel.isAdmin
            ?Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: dimensions.isPc ? Size(460, 460) : Size(380, 380),
                    painter: ConnectionBackground(),
                  ),
                  NewConnectionButton(authorized: userModel.isAdmin,)
                ]
              ),
            )
            :Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("x_X", style: TextStyle(fontSize: dimensions.isPc ? 120 : 100, fontWeight: FontWeight.bold),),
                  Text("No connection available.\nContact the administrator.", style: TextStyle(fontSize: dimensions.isPc ? 18 : 15), textAlign: TextAlign.center,)
                ],
              ),
            );
          }
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