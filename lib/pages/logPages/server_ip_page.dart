import 'package:flutter/material.dart';
import 'package:rem_app/components/logScreen/log_screen_components.dart';
import 'package:rem_app/dimensions.dart';

class ServerIpPage extends StatefulWidget {
  const ServerIpPage({super.key, required this.serverIpController});

  final TextEditingController serverIpController;

  @override
  // ignore: library_private_types_in_public_api
  _ServerIpPageState createState() => _ServerIpPageState();
}

class _ServerIpPageState extends State<ServerIpPage> {

  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions();

    return Container(
      alignment: Alignment.center,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: dimensions.logScreenTextBoxHeight,
                child: LogScreenTextBox(
                  placeholder_: "Server Ip Address", controller_: widget.serverIpController),
              )
            ],
          ),
        ),
      ),
    );
  }
}
