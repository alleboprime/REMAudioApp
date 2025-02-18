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
      required this.isPrimary});

  final String text;
  final bool isPrimary;

  final double? height_, width_;

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
    builder: (context, model, child){
      return GestureDetector(
        onTap: () => model.isLogging = !model.isLogging,
        child: Text(text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontFamily: "inter",
              decoration: TextDecoration.none,
            )),
      );
    },
  );
}


class LogScreenTextBox extends SizedBox{
  const LogScreenTextBox({super.key, required this.width_, required this.height_, required this.placeholder});

  final String placeholder;

  final double width_, height_;

  @override
  double? get width => width_ * 0.8;

  @override
  double? get height => height_ * 0.07;

  @override
  Widget? get child => ShadInput(
              style: TextStyle(fontSize: 17),
              placeholder: Text(placeholder),
            );
}