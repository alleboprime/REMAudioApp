import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/models/user_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LogScreenButton extends ShadButton {
  const LogScreenButton(
      {super.key,
      this.height_,
      this.width_,
      required this.text,
      required this.action});

  final String text;

  final double? height_, width_;

  final VoidCallback action;

  @override
  ValueChanged<TapUpDetails>? get onTapUp => (_) => action();

  @override
  Widget? get child => Text(
        text,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: "inter",
            fontSize: 17),
      );

  @override
  Color? get backgroundColor => Color.fromRGBO(250, 250, 250, 1);

  @override
  double? get width => width_;

  @override
  double? get height => height_;

  @override
  ShadDecoration? get decoration =>
      ShadDecoration(border: ShadBorder(radius: BorderRadius.circular(30)));
}

class LogScreenText extends Container {
  LogScreenText({super.key, required this.text});

  final String text;

  @override
  Widget? get child => Consumer<UserModel>(
        builder: (context, model, child) {
          return GestureDetector(
            onTap: () => model.isLogging = !model.isLogging,
            child: Text(text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: "inter",
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                  decorationStyle: TextDecorationStyle.solid,
                  decorationThickness: 1,
                )),
          );
        },
      );
}

class LogScreenTextBox extends StatefulWidget {
  const LogScreenTextBox({super.key, required this.placeholder_, required this.controller_});

  final String placeholder_;
  final TextEditingController controller_;

  @override
  // ignore: library_private_types_in_public_api
  _LogScreenTextBoxState createState() => _LogScreenTextBoxState();
}

class _LogScreenTextBoxState extends State<LogScreenTextBox> {
  bool obscured = true;

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      controller: widget.controller_,
      obscureText: (widget.placeholder_ == "Password" || widget.placeholder_ == "Confirm Password") ? obscured : false,
      placeholder: Text(widget.placeholder_),
      suffix: (widget.placeholder_ == "Password" || widget.placeholder_ == "Confirm Password")
          ? ShadButton(
              backgroundColor: Colors.transparent,
              width: 24,
              height: 24,
              padding: EdgeInsets.zero,
              decoration: const ShadDecoration(
                secondaryBorder: ShadBorder.none,
                secondaryFocusedBorder: ShadBorder.none,
              ),
              icon: Icon(obscured ? LucideIcons.eye : LucideIcons.eyeOff),
              foregroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  obscured = !obscured;
                });
              },
              hoverBackgroundColor: Colors.transparent,
              hoverForegroundColor: Colors.white,
            )
          : null,
    );
  }
}
