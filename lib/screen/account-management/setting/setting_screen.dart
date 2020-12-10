import 'package:flutter/material.dart';
import 'package:world_wisdom/model/authentication_model.dart';
import 'package:world_wisdom/model/user.dart';
import 'package:provider/provider.dart';
import 'package:world_wisdom/screen/key/key.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    User _user = context.select((AuthenticationModel model) => model.user);
    print(_user);
    return Scaffold(
      appBar: AppBar(title: Text("Setting")),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 35),
        child: ListView(
          children: [
            _user != null
                ? ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_user.avatar),
                    ),
                    title: Text(_user.name != null ? _user.name : ""),
                    onTap: () {},
                  )
                : SizedBox(),
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
                  Keys.appNavigationKey.currentState
                      .pushNamed("/authentication/login");
                },
                child: Text("SIGN IN"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
