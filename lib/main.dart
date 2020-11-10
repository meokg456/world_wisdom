import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_wisdom/screen/authentication/LoginScreen.dart';
import 'package:world_wisdom/screen/MainScreen.dart';
import 'file:///C:/Users/pc/AndroidStudioProjects/world_wisdom/lib/screen/CourseKey.dart';

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
    return MaterialApp(
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
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
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
        '/': (context) => MainScreen(key: CourseKey.globalKey),
        '/login': (context) => LoginScreen()
      },
    );
  }
}
