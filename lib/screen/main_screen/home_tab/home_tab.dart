import 'package:flutter/material.dart';
import 'package:world_wisdom/screen/key/key.dart';
import 'package:world_wisdom/screen/main_screen/main_app_bar/main_app_bar.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainTabAppBar("Home"),
      body: Container(
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
                  BottomNavigationBar bottomNavigationBar =
                      Keys.bottomNavigationBarKey.currentWidget;
                  bottomNavigationBar.onTap(2);
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
                  BottomNavigationBar bottomNavigationBar =
                      Keys.bottomNavigationBarKey.currentWidget;
                  bottomNavigationBar.onTap(3);
                }),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 20),
              child: Text(
                "Search the library",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
