import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:world_wisdom/screen/account-management/setting/setting_screen.dart';
import 'package:world_wisdom/screen/authentication/forget_password/forget_password_screen.dart';
import 'package:world_wisdom/screen/authentication/login_screen/login_screen.dart';
import 'package:world_wisdom/screen/authentication/register/register_screen.dart';
import 'package:world_wisdom/screen/constants/constants.dart';
import 'package:world_wisdom/screen/key/key.dart';
import 'package:world_wisdom/screen/main_screen/main_screen.dart';

import 'model/authentication_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Theme.of(context).textTheme.apply(
          fontFamily: GoogleFonts.roboto().fontFamily,
          bodyColor: Color(0xFF0084BD),
        );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationModel())
      ],
      child: MaterialApp(
        theme: Constants.themeData,
        initialRoute: '/',
        navigatorKey: Keys.appNavigationKey,
        routes: {
          '/': (context) => MainScreen(),
          '/authentication/login': (context) => LoginScreen(),
          '/authentication/forgot': (context) => ForgotPasswordScreen(),
          '/authentication/register': (context) => RegisterScreen(),
        },
      ),
    );
  }
}
