import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget{
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => LandingScreenState();
}

class LandingScreenState extends State<LandingScreen>{

  @override
  Widget build(BuildContext context){
    return Center(child: Text("CIAO"),);
  }

  void wait(){
    Future.delayed(Duration(seconds: 2), () => Navigator.pushReplacementNamed(context, "/home"),);
  }

  @override
  void initState() {
    wait();
    super.initState();
  }
}