import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/components/homeScreen/home_screen_components.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/application_model.dart';
import 'package:rem_app/models/user_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions();
    final colors = AppColors();

    return SafeArea(
      child: Consumer2<UserModel, ApplicationModel>(
        builder: (context, userModel, appModel, child){
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(top: 60, left: 50, right: 50),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withAlpha(40),
                        BlendMode.srcATop,
                      ),
                      "assets/rem_logo.svg"
                    )
                  )
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: dimensions.isPc ? 400 : 300,
                    child: ListView(
                      children: [
                        SettingsTile(title: "Change Theme", iconOrigin: PhosphorIcons.moon(), action: (_)=>(),),
                        Divider(thickness: 4, color: colors.primaryColor, height: 4,),
                        SettingsTile(title: "Change Language", iconOrigin: PhosphorIcons.translate(), action: (_)=>()),
                        Divider(thickness: 4, color: colors.primaryColor, height: 4,),
                        if(userModel.isAdmin)
                          SettingsTile(
                            title: "Matrix Connection", 
                            iconOrigin: PhosphorIcons.network(), 
                            action: (_)async{
                              bool result = await appModel.checkForMatrixConnections();
                              if(result){
                                if(context.mounted){Navigator.pushNamed(context, "/matrix_connection");}
                              }
                            }
                          ),
                        if(userModel.isAdmin)
                          Divider(thickness: 4, color: colors.primaryColor, height: 4,),
                        SettingsTile(
                          title: "Log Out", 
                          iconOrigin: PhosphorIcons.signOut(), 
                          action: (_) {
                            appModel.socket?.close();
                            Navigator.pushNamedAndRemoveUntil(context, '/access', (Route<dynamic> route) => false);
                          }, 
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          );
        },
      )
    );
  }
}