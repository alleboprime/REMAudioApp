import 'package:flutter/material.dart';

class PresetPreferencesPage extends StatefulWidget{
  const PresetPreferencesPage({super.key});

  @override
  State<PresetPreferencesPage> createState() => PresetPreferencesPageState();
}

class PresetPreferencesPageState extends State<PresetPreferencesPage>{

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Presets"),);
  }
}