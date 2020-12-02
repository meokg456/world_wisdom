import 'package:flutter/material.dart';
import 'package:world_wisdom/screen/main_screen/main_screen_key.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 80, bottom: 20),
            child: Text(
              "Let's get you started",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.apps_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                MainKey.mainKey.currentState.selectedTab(2);
              }),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 30),
            child: Text(
              "Browse new & popular courses",
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                MainKey.mainKey.currentState.selectedTab(3);
              }),
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 20),
            child: Text(
              "Search the library",
            ),
          ),
        ],
      ),
    );
  }
}
