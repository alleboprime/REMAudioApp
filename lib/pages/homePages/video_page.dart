import 'package:flutter/material.dart';
import 'package:mjpeg_view/mjpeg_view.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/components/homeScreen/home_screen_components.dart';
import 'package:rem_app/components/matrixScreen/matrix_screen_components.dart';
import 'package:rem_app/models/application_model.dart';
import 'package:rem_app/models/user_model.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  VideoPageState createState() => VideoPageState();
}

class VideoPageState extends State<VideoPage>{

  final userModel = UserModel();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ApplicationModel>(
        builder: (context, appModel, child){

          Widget reducedWidget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(dimensions.screenHeight >= 400)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: MjpegView(
                      uri: 'http://${userModel.remoteServerIp}/stream?a=MTkyLjE2OC4xOS40Mzo4NTU0',
                    )
                  ),
                ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              spacing: 20,
                              children: [
                                PresetButton(height: 50, fontSize: dimensions.isPc ? 22 : 18, text: appModel.cameraPresetLabels[appModel.currentMatrixPreset.toString()] ?? "Preset", previousPage: 2),
                                zoomPanel(),
                                commandGrid(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ),
            ],
          );

          return appModel.cameraConnected
          ? Center(
            child: reducedWidget,
          )
          : Center(
            child: Text("NO CAMERA CONNECTED"),
          );
        },
      )
    );
  }

  Container commandGrid() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: dimensions.isPc ? 200 : 150,
        maxWidth: dimensions.isPc ? 200 : 150,
      ),
      decoration: BoxDecoration(
        color: colors.primaryColor,
        border: Border.all(color: dimensions.isDesktop ? colors.selectionColor : Colors.transparent, width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.all(10),
      child: Consumer<ApplicationModel>(
        builder: (context, appModel, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ActionButton(iconData: PhosphorIcons.arrowLeft(), primaryAction: () => appModel.moveCamera(direction: "left", velocity: "medium"), secondaryAction: () => appModel.moveCamera(direction: "left", velocity: "fast"),),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ActionButton(iconData: PhosphorIcons.arrowUp(), primaryAction: () => appModel.moveCamera(direction: "up", velocity: "medium"), secondaryAction: () => appModel.moveCamera(direction: "up", velocity: "fast"),),
                    ActionButton(iconData: PhosphorIcons.arrowsClockwise(), primaryAction: () => appModel.moveCamera(resetPosition: true)),
                    ActionButton(iconData: PhosphorIcons.arrowDown(), primaryAction: () => appModel.moveCamera(direction: "down", velocity: "medium"), secondaryAction: () => appModel.moveCamera(direction: "down", velocity: "fast"),),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ActionButton(iconData: PhosphorIcons.arrowRight(), primaryAction: () => appModel.moveCamera(direction: "right", velocity: "medium"), secondaryAction: () => appModel.moveCamera(direction: "right", velocity: "fast"),),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Row zoomPanel(){
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ActionButton(iconData: PhosphorIcons.minusCircle(), primaryAction: () => {},),
        Text("ZOOM"),
        ActionButton(iconData: PhosphorIcons.plusCircle(), primaryAction: () => {},),
      ],
    );
  }

}
