import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 35),
      child: ListView(
        children: [
          ListTile(
            title: Text(
              "Captions",
              style: Theme.of(context).textTheme.headline6,
            ),
            dense: true,
          ),
          ListTile(
            title: Text(
              "Notifications",
              style: Theme.of(context).textTheme.headline6,
            ),
            dense: true,
          ),
          ListTile(
            title: Text(
              "App version",
              style: Theme.of(context).textTheme.headline6,
            ),
            dense: true,
            subtitle: Text(
              "2.38.0",
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/authentication/login");
              },
              child: Text("SIGN IN"),
            ),
          )
        ],
      ),
    );
  }
}
