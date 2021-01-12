import 'package:flutter/material.dart';
import 'package:world_wisdom/generated/l10n.dart';
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
      appBar: MainTabAppBar(S.of(context).download),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Icon(
                Icons.arrow_circle_down_outlined,
                size: 100,
                color: Color(0xFF2D3137),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Text(
                  S.of(context).downloadHint,
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 20),
                child: Text(
                  S.of(context).downloadDescriptions,
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
                      S.of(context).browseNavigateButtonText,
                      style: Theme.of(context).textTheme.button,
                    )),
              ),
              Container(
                margin: EdgeInsets.only(top: 40, bottom: 5),
                child: Text(S.of(context).downloadGuideHint),
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
      ),
    );
  }
}
