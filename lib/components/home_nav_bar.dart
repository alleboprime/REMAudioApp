import 'package:flutter/material.dart';
import 'package:rem_app/components/home_nav_bar_entry.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeNavBar extends StatelessWidget{
  HomeNavBar({super.key});


  final List<HomeNavBarEntry> entries = [
        HomeNavBarEntry(title: "Panoramica", icon: PhosphorIcons.house(), route: "/"),
        HomeNavBarEntry(title: "Audio", icon: PhosphorIcons.speakerHigh(), route: "/audio"),
        HomeNavBarEntry(title: "Video", icon: PhosphorIcons.videoCamera(), route: "/video"),
        HomeNavBarEntry(title: "Settings", icon: PhosphorIcons.slidersHorizontal(), route: "/settings"),
      ];


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.09,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(30, 30, 30, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: entries,
      ),
    );
  }
}
