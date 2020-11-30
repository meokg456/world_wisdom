import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:world_wisdom/screen/main_screen/main_screen_key.dart';
import 'file:///D:/AndroidStudioProjects/world_wisdom/lib/screen/authentication/forget_password/forget_password_screen.dart';
import 'file:///D:/AndroidStudioProjects/world_wisdom/lib/screen/authentication/login_screen/login_screen.dart';
import 'file:///D:/AndroidStudioProjects/world_wisdom/lib/screen/main_screen/main_screen.dart';
import 'file:///D:/AndroidStudioProjects/world_wisdom/lib/screen/authentication/register/register_screen.dart';
import 'package:world_wisdom/screen/model/authentication_model.dart';
import 'package:world_wisdom/screen/model/user_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Theme
        .of(context)
        .textTheme
        .apply(
      fontFamily: GoogleFonts
          .roboto()
          .fontFamily,
      bodyColor: Color(0xFF0084BD),
    );
    return
      MultiProvider(
        providers: [
          Provider(create: (_) => AuthenticationModel())
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primaryColor: Color(0xFF181C20),
              accentColor: Color(0xFF0084BD),
              scaffoldBackgroundColor: Color(0xFF0D0F12),
              cardColor: Color(0xFF181C20),
              dialogBackgroundColor: Color(0xFF2d3436),
              canvasColor: Color(0xFF181C20),
              focusColor: Color(0xFF0084BD),
              //0081B9 //0084BD
              brightness: Brightness.dark,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textButtonTheme: TextButtonThemeData(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFF181C20)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                  )),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF0084BD)))),
              outlinedButtonTheme: OutlinedButtonThemeData(
                  style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFF0084BD)),
                    side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Color(0xFF0084BD))),
                  ))),
          initialRoute: '/',
          routes: {
            '/': (context) => MainScreen(key: MainKey.mainKey),
            '/authentication/login': (context) => LoginScreen(),
            '/authentication/forgot': (context) => ForgotPasswordScreen(),
            '/authentication/register': (context) => RegisterScreen(),
          },
        ),
      );
  }
}
