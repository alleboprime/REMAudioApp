import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/components/matrixScreen/matrix_screen_components.dart';
import 'package:rem_app/components/scrolling_label.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/application_model.dart';
import 'package:rem_app/models/common_interface.dart';
import 'package:rem_app/models/home_nav_bar_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
      child: Consumer3<ApplicationModel, CommonInterface, HomeNavBarModel>(
        builder: (context, appModel, commonInterface, navBarModel, child) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  toolbarHeight: 100,
                  surfaceTintColor: Colors.black,
                  leadingWidth: dimensions.isPc ? 150 : 90,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.transparent,
                  leading: Consumer<HomeNavBarModel>(
                    builder: (context, navBar, child) {
                      return Row(
                        children: [
                          SizedBox(width: dimensions.isPc ? 50 : 20),
                          ActionButton(iconData: PhosphorIcons.arrowLeft(), primaryAction: () => navBar.selectedPage = navBar.previousPage,),
                        ],
                      );
                    }
                  ),
                ),
                body: Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 600,
                        maxHeight: 600,
                      ),
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
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final navBarModel = Provider.of<HomeNavBarModel>(context);
          
                                    Map<String, String> labels = navBarModel.matrixPreset ? appModel.matrixPresetLabels : appModel.cameraPresetLabels;
                                    int currentPreset = navBarModel.matrixPreset ? appModel.currentMatrixPreset : appModel.currentCameraPreset;
                                    int offset = navBarModel.matrixPreset ? 1 : 0;
                                    int rowNumber = ((navBarModel.matrixPreset ? appModel.matrixPresetLabels.length : appModel.cameraPresetLabels.length)/2).toInt();
                                    Widget content = Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      spacing: 30,
                                      children: List.generate(rowNumber, (rowIndex) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: List.generate(2, (colIndex) {
                                            return ShadButton.outline(
                                              onTapUp: (_) async {
                                                commonInterface.isLoading = true;
                                                bool result = await appModel.setPreset(navBarModel.matrixPreset, rowIndex * 2 + colIndex + offset);
                                                commonInterface.isLoading = false;
                                                if(!result){
                                                  commonInterface.failingReason = "Failed setting preset";
                                                }
                                                navBarModel.selectedPage = navBarModel.previousPage;
                                              },
                                              hoverBackgroundColor: Colors.transparent,
                                              width: 120,
                                              height: 50,
                                              padding: EdgeInsets.all(0),
                                              decoration: ShadDecoration(
                                                border: ShadBorder.all(
                                                  color: (currentPreset == (rowIndex * 2 + colIndex + offset)) 
                                                    ? colors.selectionColor 
                                                    : Colors.white, 
                                                  radius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: ScrollingLabel(
                                                width: 100,
                                                maxCharCount: 10,
                                                text: labels["${rowIndex * 2 + colIndex + offset}"].toString(),
                                                color: (currentPreset == (rowIndex * 2 + colIndex + offset))
                                                    ? colors.selectionColor
                                                    : Colors.white,
                                              ),
                                            );
                                          }),
                                        );
                                      }),
                                    );
                                    return Center(child: SingleChildScrollView(child: content));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ),
                ),
              ),
              if(!appModel.matrixAvailable && navBarModel.matrixPreset)
                deviceUnavailable("Matrix", 235),
              if(!appModel.cameraAvailable && !navBarModel.matrixPreset)
                deviceUnavailable("Camera", 245),
            ],
          );
        }
      ),
    );
  }
  
  Container deviceUnavailable(String device, double width) {
    return Container(
      color: Colors.black.withAlpha(100),
      child: Center(
        child: SizedBox(
          width: width,
          child: ShadAlert(
            decoration: ShadDecoration(
              color: Colors.black,
              border: ShadBorder.all(color: Colors.yellow, width: 2)
            ),
            iconData: LucideIcons.clock,
            iconColor: Colors.yellow,
            title: Text('$device Unavailable', style: TextStyle(color: Colors.yellow, fontSize: 18)),
            description:
                Text('Please wait...', style: TextStyle(color: Colors.yellow, fontSize: 17),),
          ),
        )
      ),
    );
  }
}