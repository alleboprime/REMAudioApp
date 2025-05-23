import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mjpeg_view/mjpeg_view.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/components/homeScreen/home_screen_components.dart';
import 'package:rem_app/components/matrixScreen/matrix_screen_components.dart';
import 'package:rem_app/models/application_model.dart';
import 'package:rem_app/models/user_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  VideoPageState createState() => VideoPageState();
}

class VideoPageState extends State<VideoPage>{

  final userModel = UserModel();

  final rtspController = ShadTextEditingController();

  Client? client;

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
                    child: Center(
                      child: appModel.rtspURLFragment.isEmpty
                        ?onDoneWidget(appModel)
                        :MjpegView(
                          client: client,
                          doneWidget: (context) {
                            client?.close();
                            return onDoneWidget(appModel);
                          },
                          onError: (error, stackTrace) {
                            setState(() {
                              appModel.rtspURLFragment = "";
                            });
                          },
                          errorWidget: (context) {
                            return SizedBox.shrink();
                          },
                          timeout: Duration(seconds: 5),
                          uri: 'http://${userModel.remoteServerIp}/stream?a=${appModel.rtspURLFragment}',
                        ),
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
                                PresetButton(matrixPreset: false, height: 50, fontSize: dimensions.isPc ? 22 : 18, text: appModel.cameraPresetLabels[appModel.currentCameraPreset.toString()] ?? "Preset", previousPage: 2),
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

  Row onDoneWidget(ApplicationModel appModel) {
    return Row(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          height: 50,
          child: ShadInput(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            placeholder: Text("RTSP Port"),
            controller: rtspController,
          ),
        ),
        ShadButton(
          width: 40,
          height: 40,
          icon: Icon(PhosphorIcons.check(), size: 28,),
          onTapUp: (value) {
            String encodedSocket = base64Url.encode(utf8.encode("${appModel.cameraSocket.split(":")[0]}:${rtspController.text}")).replaceAll("=", "");
            setState(() {
              appModel.rtspURLFragment = encodedSocket;
            });
            client = Client();
            client?.get(Uri.parse("http://${userModel.remoteServerIp}/stream?a=${appModel.rtspURLFragment}"));
          },
        )
      ],
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
    final appModel = ApplicationModel();
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ActionButton(iconData: PhosphorIcons.minusCircle(), isZoom: true, primaryAction: appModel.zoomWide, secondaryAction: appModel.zoomStop,),
        Text("ZOOM"),
        ActionButton(iconData: PhosphorIcons.plusCircle(), isZoom: true, primaryAction: appModel.zoomTele, secondaryAction: appModel.zoomStop,),
      ],
    );
  }

}
