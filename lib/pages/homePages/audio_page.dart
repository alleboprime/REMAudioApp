import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/models/matrix_model.dart';

class AudioPage extends Container {
  AudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<MatrixModel>(
        builder: (context, matrixModel, child){
          return matrixModel.latestMatrixSocketAvailable
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
