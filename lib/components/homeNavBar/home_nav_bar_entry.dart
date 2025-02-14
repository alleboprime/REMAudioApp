import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/models/home_nav_bar_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomeNavBarEntry extends StatelessWidget {
  const HomeNavBarEntry({super.key, required this.title, required this.icon, required this.pageIndex});

  final String title;
  final IconData icon;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return ShadTooltip(
      decoration: ShadDecoration(
        color: Colors.transparent,
      ),
      builder: (context) => Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
        ),
      ),
      child: Consumer<HomeNavBarModel>(
        builder: (context, model, child){
          return TweenAnimationBuilder(
            duration: const Duration(milliseconds: 130),
            tween: ColorTween(
              begin: model.selectedPage == pageIndex ? Colors.white : Color.fromRGBO(0, 122, 255, 1),
              end: model.selectedPage == pageIndex ? Color.fromRGBO(0, 122, 255, 1) : Colors.white,
            ),
            builder: (context, color, child){
              return ShadButton(
                
                backgroundColor: Colors.transparent,
                foregroundColor: color,
                pressedForegroundColor: Colors.white,
                pressedBackgroundColor: Colors.transparent,
                icon: PhosphorIcon(
                  icon,
                  size: MediaQuery.of(context).size.width * 0.065,
              
                  ),
                onPressed: () {
                  model.setSelectedPage(pageIndex);
                },
              );
            },
          );
        }
        ),
    );
  }
}
