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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChangeNotifierProvider(
        create: (context) => UserModel(),
        child: Consumer<UserModel>(
          builder: (context, model, child) {
            return IndexedStack(
              index: model.isLogging ? 0 : 1,
              children: [
                LoginPage(context: context),
                RegisterPage(context: context),
              ],
            );
          },
        )
        )
    );
  }
}
