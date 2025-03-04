import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:world_wisdom/generated/l10n.dart';
import 'package:world_wisdom/model/authentication_model/authentication_model.dart';
import 'package:world_wisdom/model/authentication_model/user_model/user.dart';
import 'package:world_wisdom/model/authentication_model/user_model/user_model.dart';
import 'package:world_wisdom/model/course_model/course_detail.dart';
import 'package:world_wisdom/model/course_model/downloaded_courses_model.dart';
import 'package:world_wisdom/screen/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:world_wisdom/sql_lite/database_connector.dart';

class SplashScreen extends StatelessWidget {
  Future<void> loadData(BuildContext context) async {
    DownloadedCoursesModel downloadedCoursesModel =
        Provider.of(context, listen: false);
    Database database = await DatabaseConnector.database;
    var data = await database.query("courses");

    for (var json in data) {
      CourseDetail courseDetail =
          CourseDetail.fromJson(jsonDecode(json["data"]));
      var imageUrlData = await database
          .query("images", where: "courseId = ?", whereArgs: [courseDetail.id]);
      for (var imagePath in imageUrlData)
        courseDetail.imageUrl = imagePath["imagePath"];
      var videoUrlData = await database
          .query("videos", where: "id = ?", whereArgs: [courseDetail.id]);
      for (var videoPath in videoUrlData)
        courseDetail.promoVidUrl = videoPath["videoPath"];
      downloadedCoursesModel.add(courseDetail);
      for (var section in courseDetail.sections) {
        for (var lesson in section.lessons) {
          var videoUrlData = await database
              .query("videos", where: "id = ?", whereArgs: [lesson.id]);
          for (var videoPath in videoUrlData)
            lesson.currentProgress.videoUrl = videoPath["videoPath"];
        }
      }
    }
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
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    loadData(context).whenComplete(() {
      Navigator.pop(context);
      Navigator.pushNamed(context, "/main");
    });
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
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
                'World wisdom',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(
                height: 150,
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).accentColor),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                S.of(context).appHint,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
