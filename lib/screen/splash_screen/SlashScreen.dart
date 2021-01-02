import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_wisdom/model/authentication_model/authentication_model.dart';
import 'package:world_wisdom/model/authentication_model/user_model/user.dart';
import 'package:world_wisdom/model/authentication_model/user_model/user_model.dart';
import 'package:world_wisdom/screen/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  Future<void> loadData(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");

    if (token != null) {
      var response = await http.get("${Constants.apiUrl}/user/me", headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });
      if (response.statusCode == 200) {
        print(response.body);
        UserModel userModel = UserModel();
        userModel.token = token;
        userModel.userInfo =
            User.fromJson(jsonDecode(response.body)["payload"]);
        context.read<AuthenticationModel>().setAuthenticationModel(userModel);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    loadData(context).whenComplete(() {
      Navigator.pop(context);
      Navigator.pushNamed(context, "/main");
    });
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 230,
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50,
              child: Image.asset(
                'resources/images/online-course.png',
                height: 70,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'ITEdu',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(
              height: 150,
            ),
            CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Online courses\n for students',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
