import 'package:flutter/material.dart';
import 'package:world_wisdom/screen/course/Course.dart';
import 'package:world_wisdom/screen/course/CourseKey.dart';
import 'package:world_wisdom/screen/course/CourseScreenState.dart';
import 'package:world_wisdom/screen/setting/SettingScreen.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: Typography.englishLike2018,
        primaryColor: Color(0xFF181C20),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF4B4F53)
            ),
          ),

        ),
        scaffoldBackgroundColor: Color(0xFF0D0F12),
        cardColor: Color(0xFF181C20),
        dialogBackgroundColor: Color(0xFF2d3436),
        canvasColor: Color(0xFF181C20),
        //0081B9 //0084BD
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF181C20)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            )),
          )
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0084BD))
          )
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => CourseScreen(key: CourseKey.globalKey),
        '/settings' : (context) => SettingScreen(),
      },
    );
  }
}

