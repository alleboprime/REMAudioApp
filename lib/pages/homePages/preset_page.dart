import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/application_model.dart';
import 'package:rem_app/models/common_interface.dart';

class PresetPage extends StatefulWidget{
  const PresetPage({super.key});

  @override
  PresetPageState createState() => PresetPageState();
}

class PresetPageState extends State<PresetPage>{
  final dimensions = Dimensions();
  final colors = AppColors();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Consumer2<ApplicationModel, CommonInterface>(
          builder: (context, appModel, commonInterface, child) {
            return Center(
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
            );
          }
        ),
      ),
    );
  }
}