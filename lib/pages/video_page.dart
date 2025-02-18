import 'package:flutter/material.dart';

class VideoPage extends Container {
  VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(
        child: Text("Video"),
      ),
    );
  }
}
