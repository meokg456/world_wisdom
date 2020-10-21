import 'dart:collection';

import 'package:flutter/material.dart';

import 'Tab/HomeTab.dart';

class CourseScreen extends StatefulWidget {
  @override
  _CourseScreenState createState() => _CourseScreenState();
}

enum MenuItem { setting, feedback, support }

class _CourseScreenState extends State<CourseScreen> {

  String tabName = "Home";

  var tabMap = {
    'Home': HomeTab(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tabName
      ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {},
          ),
          PopupMenuButton<MenuItem>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
              const PopupMenuItem<MenuItem>(
                value: MenuItem.setting,
                child: Text('Settings'),
              ),
              const PopupMenuItem<MenuItem>(
                value: MenuItem.feedback,
                child: Text('Send feedback'),
              ),
              const PopupMenuItem<MenuItem>(
                value: MenuItem.setting,
                child: Text('Contrast support'),
              ),

            ],
          )
        ],
      ),
      body: tabMap[tabName],
    );
  }
}

