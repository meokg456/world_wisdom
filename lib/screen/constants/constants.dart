import 'package:flutter/material.dart';

class Constants {
  static String apiUrl = "https://api.letstudy.org";
  static ThemeData themeData = ThemeData(
      primaryColor: Color(0xFF181C20),
      accentColor: Color(0xFF0084BD),
      scaffoldBackgroundColor: Color(0xFF0D0F12),
      cardColor: Color(0xFF181C20),
      dialogBackgroundColor: Color(0xFF2d3436),
      canvasColor: Color(0xFF181C20),
      focusColor: Color(0xFF0084BD),
      snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xFF181C20),
          contentTextStyle: TextStyle(color: Colors.white, fontSize: 18)),
      //0081B9 //0084BD
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF181C20)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFF0084BD)))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF0084BD)),
        side: MaterialStateProperty.all<BorderSide>(
            BorderSide(color: Color(0xFF0084BD))),
      )));
}
