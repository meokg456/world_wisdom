import 'package:flutter/material.dart';
import 'package:world_wisdom/Screen/Course.dart';

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
        primaryColor: Color(0xFF2d3436),
        scaffoldBackgroundColor: Colors.black,
        cardColor: Color(0xFF2d3436),
        dialogBackgroundColor: Color(0xFF2d3436),
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),
      initialRoute: '/',
      routes: {
        '/': (context) => CourseScreen(),
      },
    );
  }
}

