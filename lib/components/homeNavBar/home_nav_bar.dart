import 'package:flutter/material.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/components/homeNavBar/home_nav_bar_entry.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeNavBar extends StatelessWidget{
  HomeNavBar({super.key});


  final List<HomeNavBarEntry> entries = [
        HomeNavBarEntry(title: "Panoramica", icon: PhosphorIcons.house(), pageIndex: 0,),
        HomeNavBarEntry(title: "Audio", icon: PhosphorIcons.speakerHigh(), pageIndex: 1,),
        HomeNavBarEntry(title: "Video", icon: PhosphorIcons.videoCamera(), pageIndex: 2,),
        HomeNavBarEntry(title: "Settings", icon: PhosphorIcons.slidersHorizontal(), pageIndex: 3,),
      ];


  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: colors.primaryColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: entries,
      ),
    );
  }
}
