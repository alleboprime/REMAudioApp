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

  final TextEditingController matrixNameController = TextEditingController();
  final TextEditingController matrixIpController = TextEditingController();
  final TextEditingController matrixPortController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar( //TODO highlighting color still visible when scrolling list view
          toolbarHeight: 100,
          leadingWidth: 90,
          backgroundColor: Colors.black,
          foregroundColor: Colors.transparent,
          leading: Row(
            children: [
              SizedBox(width: 50),
              ActionButton(iconData: PhosphorIcons.arrowLeft(), action: () => Navigator.pop(context),),
            ],
          ),
          actions: [
            SizedBox(width: 90),
          ],
          title: Center(child: Text("CREATE CONNECTIONS", style: TextStyle(color: Colors.white, fontSize: dimensions.isPc ? 20 : 15),),)
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 30),
            child: Consumer2<UserModel, MatrixModel>(
              builder: (context, userModel, matrixModel, child) {
                return userModel.isAdmin
                ?Center(
                  child: Container(
                    width: 600,
                    height: 600,
                    decoration: BoxDecoration(
                      color: colors.primaryColor,
                      border: Border.all(color: dimensions.isPc ? colors.selectionColor : colors.primaryColor),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            
                            
                          ],
                        ),
                      ),
                    ),
                  )
                )
                :Align(
                  alignment: Alignment.topCenter,
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
        ),
      ),
    );
  }
}