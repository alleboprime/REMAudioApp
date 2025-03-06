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

class LogScreenText extends Container {
  LogScreenText({super.key, required this.text, this.isFormTooltip = false});

  final String text;
  final bool isFormTooltip;

  @override
  Widget? get child => Consumer<UserModel>(
        builder: (context, model, child) {
          return GestureDetector(
            onTap: () => isFormTooltip ? () : model.isLogging = !model.isLogging,
            child: Text(text,
                style: TextStyle(
                  color: isFormTooltip ? colors.logScreenFormTooltip : Colors.white,
                  fontSize: isFormTooltip ? 14 : 17,
                  fontFamily: "inter",
                  fontWeight: isFormTooltip ? FontWeight.normal : FontWeight.bold,
                  decoration: TextDecoration.none
                )),
          );
        },
      );
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
