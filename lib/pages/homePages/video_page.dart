import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/models/application_model.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  VideoPageState createState() => VideoPageState();
}

class VideoPageState extends State<VideoPage>{

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ApplicationModel>(
        builder: (context, appModel, child){
          return appModel.cameraConnected
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
