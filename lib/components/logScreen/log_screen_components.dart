import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/models/user_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

final colors = AppColors();

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
  Color? get backgroundColor => colors.logScreenButtonColor;

  @override
  double? get width => width_;

  @override
  double? get height => height_;

  @override
  ShadDecoration? get decoration =>
      ShadDecoration(border: ShadBorder(radius: BorderRadius.circular(30)));
}

class LogScreenText extends StatefulWidget {
  const LogScreenText({super.key, required this.text});

  final String text;

  @override
  // ignore: library_private_types_in_public_api
  _LogScreenTextState createState() => _LogScreenTextState();
}

class _LogScreenTextState extends State<LogScreenText> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, model, child) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) {
            setState(() {
              isHovered = true;
            });
          },
          onExit: (_) {
            setState(() {
              isHovered = false;
            });
          },
          child: GestureDetector(
            onTap: () =>  model.isLogging = false,
            child: Container(
              decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isHovered ? Colors.white : Colors.transparent,
                          width: 1,
                        ),
                      ),
                    ),
              padding: EdgeInsets.only(bottom: 1),
              child: Text(
                widget.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: "inter",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LogScreenTextBox extends StatefulWidget {
  const LogScreenTextBox({super.key, required this.placeholder_, required this.controller_, this.isPasswordBox = false});

  final String placeholder_;
  final TextEditingController controller_;
  final bool isPasswordBox;

  @override
  // ignore: library_private_types_in_public_api
  _LogScreenTextBoxState createState() => _LogScreenTextBoxState();
}

class _LogScreenTextBoxState extends State<LogScreenTextBox> {
  bool obscured = true;

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      style: TextStyle(fontSize: 17),
      controller: widget.controller_,
      obscureText: (widget.isPasswordBox) ? obscured : false,
      placeholder: Text(widget.placeholder_),
      suffix: (widget.isPasswordBox)
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
