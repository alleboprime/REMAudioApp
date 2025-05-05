import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/models/matrix_model.dart';

class VideoPage extends Container {
  VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<MatrixModel>(
        builder: (context, matrixModel, child){
          return matrixModel.latestCameraSocketAvailable
          ? Center(
            child: Text("VIDEO"),
          )
          : Center(
            child: Text("NO CAMERA CONNECTED"),
          );
        },
      )
    );
  }
}
