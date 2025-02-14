import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppBarTile extends ShadButton{
  const AppBarTile({super.key, required this.title});

  final String title;

  @override
  Color? get backgroundColor => Colors.black;

  @override
  Color? get foregroundColor => Colors.white;

  @override
  // TODO: implement decoration
  ShadDecoration? get decoration => ShadDecoration(border: ShadBorder.all(color: Colors.white, width: 1));

  @override
  double? get height => 35;

  @override
  double? get width => 80;

  @override
  Widget? get child => Text(title);
}