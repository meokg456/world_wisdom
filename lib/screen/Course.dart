import 'dart:collection';

import 'package:flutter/material.dart';

import 'Tab/HomeTab.dart';

class CourseScreen extends StatefulWidget {
  @override
  _CourseScreenState createState() => _CourseScreenState();
}

enum MenuItem { setting, feedback, support }

class _CourseScreenState extends State<CourseScreen> {

  int selectedIndex = 0;

  var tabNames = ['Home', 'Downloads', 'Browse', 'Search'];

  var tabIconMap = {
    'Home': Icons.home_outlined,
    'Downloads': Icons.download_rounded,
    'Browse': Icons.apps,
    'Search': Icons.search
  };

  var tabMap = {
    'Home': HomeTab(),
    'Downloads': Container(),
    'Browse': Container(),
    'Search': Container()
  };

  void selectedTab(int selectedItem)
  {
    setState(() {
      selectedIndex = selectedItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tabNames[selectedIndex]
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
      body: tabMap[tabNames[selectedIndex]],
      bottomNavigationBar: BottomNavigationBar(
        items:
        tabIconMap.entries.map((tab) =>
              BottomNavigationBarItem(
              icon: Icon(tab.value),
              label: tab.key
              )
          ).toList(),
        showUnselectedLabels: true,
        onTap: selectedTab,
        currentIndex: selectedIndex,
        unselectedItemColor: Colors.white,
        selectedItemColor: Color(0xFF0081B9),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

