import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/models/user_model.dart';
import 'package:rem_app/pages/login_page.dart';
import 'package:rem_app/pages/register_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  PageController loginScreenPageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChangeNotifierProvider(
        create: (context) => UserModel(),
        child: Consumer<UserModel>(
          builder: (context, model, child) {
            
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (model.isLogging) {
                loginScreenPageController.animateToPage(
                  0,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                );
              } else {
                loginScreenPageController.animateToPage(
                  1,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                );
              }
            });


            return PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: loginScreenPageController,              
              children: [
                LoginPage(),
                RegisterPage(),
              ]
            );
          },
        )
        )
    );
  }
}
