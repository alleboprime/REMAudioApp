import 'package:flutter/material.dart';
import 'package:rem_app/components/pageAppBar/app_bar_tile.dart';

class HomePage extends Container {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Colors.black,
        title: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color.fromRGBO(30, 30, 30, 1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppBarTile(title: "Audio",),
              SizedBox(width: 15,),
              AppBarTile(title: "Video"),
            ],
          ),
        )
      ),
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Text("Panoramica"),
        ),
      ),
    );
  }
}
