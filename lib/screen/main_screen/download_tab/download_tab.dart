import 'package:flutter/material.dart';
import 'package:world_wisdom/screen/key/key.dart';
import 'package:world_wisdom/screen/main_screen/main_app_bar/main_app_bar.dart';

class DownloadTab extends StatefulWidget {
  @override
  _DownloadTabState createState() => _DownloadTabState();
}

class _DownloadTabState extends State<DownloadTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainTabAppBar("Download"),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          children: [
            Icon(
              Icons.arrow_circle_down_outlined,
              size: 100,
              color: Color(0xFF2D3137),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Text(
                "Watch your courses on the go!",
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8, bottom: 20),
              child: Text(
                "Download courses so you can countinue to skill up-even when you're offline.",
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    BottomNavigationBar bottomNavigationBar =
                        Keys.bottomNavigationBarKey.currentWidget;
                    bottomNavigationBar.onTap(3);
                  },
                  child: Text(
                    "FIND A COURSE TO DOWNLOAD",
                    style: Theme.of(context).textTheme.button,
                  )),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, bottom: 5),
              child: Text("How to download courses"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  "resources/images/DownloadByButton.jpg",
                  height: 150,
                ),
                Image.asset(
                  "resources/images/DownloadByMenu.jpg",
                  height: 150,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
