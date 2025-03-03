import 'package:flutter/material.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/dimensions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{



  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions();
    final colors = AppColors();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: dimensions.homeScreenAppBarHeight,
        title: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: colors.primaryColor,
                ),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                child: Center(child: Text("PANORAMICA")),
              ),
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: colors.primaryColor,
                ),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                child: Center(child: Text("PANORAMICA")),
              )
            ],
          )
        ),
      ),
    );
  }

}