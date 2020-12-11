import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_wisdom/model/authentication_model.dart';
import 'package:world_wisdom/model/user.dart';
import 'package:world_wisdom/screen/key/key.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    User _user = context.select((AuthenticationModel model) => model.user);
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
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
          ],
        ),
      ),
    );
  }
}
