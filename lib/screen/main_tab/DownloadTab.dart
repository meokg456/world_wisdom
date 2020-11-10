import 'package:flutter/material.dart';

import '../CourseKey.dart';

class DownloadTab extends StatefulWidget {
  @override
  _DownloadTabState createState() => _DownloadTabState();
}

class _DownloadTabState extends State<DownloadTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 20),
            child: Text(
              "Download courses so you can countinue to skill up-even when you're offline.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  CourseKey.globalKey.currentState.selectedTab(2);
                },
                child: Text(
                  "FIND A COURSE TO DOWNLOAD",
                  style: TextStyle(fontSize: 16),
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
    );
  }
}
