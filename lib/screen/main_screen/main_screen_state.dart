import 'package:flutter/material.dart';
import 'package:world_wisdom/screen/setting_screen.dart';
import 'package:world_wisdom/screen/main_tab/browse_tab.dart';
import 'package:world_wisdom/screen/main_tab/download_tab.dart';
import 'package:world_wisdom/screen/main_tab/home_tab.dart';
import 'package:world_wisdom/screen/main_tab/search_tab.dart';

import 'main_screen.dart';

class MainScreenState extends State<MainScreen> {
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
    MenuItem.setting: SettingScreen(),
    MenuItem.feedback: Container(),
    MenuItem.support: Container()
  };

  var tabMap = {
    'Home': HomeTab(),
    'Downloads': DownloadTab(),
    'Browse': BrowseTab(),
    'Search': SearchTab()
  };

  Widget showingTab;

  @override
  void initState() {
    super.initState();
    showingTab = tabMap[tabNames[selectedIndex]];
    title = tabNames[0];
  }

  void selectedTab(int selectedItem) {
    setState(() {
      selectedIndex = selectedItem;
      FocusScope.of(context).unfocus();
      title = tabNames[selectedIndex];
      showingTab = tabMap[title];
      isOnMainTab = true;
    });
  }

  Future<bool> _onWillPop() async {
    if (isOnMainTab == true) {
      return true;
    } else {
      selectedTab(selectedIndex);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: selectedIndex != 3
            ? AppBar(
                leading: isOnMainTab
                    ? null
                    : IconButton(
                        icon: Icon(Icons.arrow_back_outlined),
                        onPressed: () {
                          setState(() {
                            selectedTab(selectedIndex);
                          });
                        }),
                title: Text(
                  title,
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.account_circle,
                      color: Colors.blue,
                    ),
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
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<MenuItem>>[
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
              )
            : AppBar(
                title: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4B4F53)),
                    ),
                  ),
                  style: TextStyle(fontSize: 24),
                ),
              ),
        body: showingTab,
        bottomNavigationBar: BottomNavigationBar(
          items: tabIconMap.entries
              .map((tab) => BottomNavigationBarItem(
                  icon: Icon(tab.value), label: tab.key))
              .toList(),
          showUnselectedLabels: true,
          onTap: selectedTab,
          currentIndex: selectedIndex,
          unselectedItemColor: Colors.white,
          selectedItemColor: Color(0xFF0081B9),
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
