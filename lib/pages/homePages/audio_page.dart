import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/models/application_model.dart';

class AudioPage extends Container {
  AudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ApplicationModel>(
        builder: (context, appModel, child){
          return appModel.matrixConnected
          ? Center(
            child: Text("AUDIO"),
          )
          : Center(
            child: Text("NO MATRIX CONNECTED"),
          );
        },
      )
    );
  }
}
