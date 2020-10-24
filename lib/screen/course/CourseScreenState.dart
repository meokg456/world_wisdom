import 'package:flutter/material.dart';
import 'package:world_wisdom/screen/course/tab/BrowseTab.dart';
import 'package:world_wisdom/screen/course/tab/DownloadTab.dart';
import 'package:world_wisdom/screen/course/tab/HomeTab.dart';

import 'Course.dart';

class CourseScreenState extends State<CourseScreen> {

  String title;

  int selectedIndex = 0;

  bool isOnMainTab = true;

  var tabNames = ['Home', 'Downloads', 'Browse', 'Search'];

  var menuNames = ["Settings", "Send feedback", "Support"];

  var tabIconMap = {
    'Home': Icons.home_outlined,
    'Downloads': Icons.arrow_circle_down_outlined,
    'Browse': Icons.apps,
    'Search': Icons.search
  };

  var configScreenMap = {
    MenuItem.setting: Container(),
    MenuItem.feedback: Container(),
    MenuItem.support: Container()
  };

  var tabMap = {
    'Home': HomeTab(),
    'Downloads': DownloadTab(),
    'Browse': BrowseTab(),
    'Search': Container()
  };

  Widget showingTab;


  @override
  void initState() {
    super.initState();
    showingTab = tabMap[tabNames[selectedIndex]];
    title = tabNames[0];
  }

  void selectedTab(int selectedItem)
  {
    setState(() {
      selectedIndex = selectedItem;
      title = tabNames[selectedIndex];
      showingTab = tabMap[title];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: isOnMainTab ? null : IconButton(
            icon: Icon(Icons.arrow_back_outlined),
            onPressed: () {
              setState(() {
                title = tabNames[selectedIndex];
                showingTab = tabMap[tabNames[selectedIndex]];
                isOnMainTab = true;
              });
            }),
        title: Text(
            title,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.blue,),
            onPressed: () {},
          ),
          PopupMenuButton<MenuItem>(
            onSelected: (item) {
              setState(() {
                showingTab = configScreenMap[item];
                title = menuNames[item.index];
                isOnMainTab = false;
              });
            },
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
                value: MenuItem.support,
                child: Text('Contrast support'),
              ),

            ],
          )
        ],
      ),
      body: showingTab,
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

