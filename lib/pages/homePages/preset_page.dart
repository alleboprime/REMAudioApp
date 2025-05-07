import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/matrix_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PresetPage extends StatefulWidget{
  const PresetPage({super.key});

  @override
  PresetPageState createState() => PresetPageState();
}

class PresetPageState extends State<PresetPage>{
  final dimensions = Dimensions();
  final colors = AppColors();

  Timer? _failedTimer;

  bool isLoading = false;

  bool _failed = false;
  bool get failed => _failed;
  set failed(bool value){
    if(value){
      _failed = true;
      _failedTimer?.cancel();
      _failedTimer = Timer(Duration(seconds: 3), () {
        if(mounted){
          setState(() => _failed = false);
        }
      });
    }else{
      setState(() => _failed = false);
    }
  }

  String _failingReason = "";
  String get failingReason => _failingReason;
  set failingReason(String value){
    _failingReason = value;
    failed = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Consumer<MatrixModel>(
          builder: (context, matrixModel, child) {
            return Stack(
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: dimensions.isDesktop ? colors.primaryColor : colors.primaryColor,
                      border: Border.all(color: dimensions.isDesktop ? colors.selectionColor : Colors.transparent, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                    child: Center(
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          child: Column(
                            spacing: 5,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("CIAO")
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ),
                if (isLoading)
                  Container(
                color: Colors.black.withAlpha(180),
                child: Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                    ),
                  ),
                ),
              ),
                if (failed)
                  Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: ShadToast(
                  backgroundColor: colors.logScreenToastColor,
                  description: Text(failingReason, style: TextStyle(fontSize: dimensions.isPc ? 17 : 14),),
                ),
              ),
              ],
            );
          }
        ),
      ),
    );
  }
}