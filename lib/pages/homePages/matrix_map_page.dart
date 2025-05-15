import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/models/application_model.dart';

class MatrixMapPage extends StatefulWidget {
  const MatrixMapPage({super.key});

  @override
  MatrixMapPageState createState() => MatrixMapPageState();
}

class MatrixMapPageState extends State<MatrixMapPage>{

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ApplicationModel>(
        builder: (context, appModel, child){
          return Center(child: Text("MATRICMAX"),);
        },
      )
    );
  }
}
