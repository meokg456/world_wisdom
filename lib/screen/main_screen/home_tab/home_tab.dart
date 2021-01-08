import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:world_wisdom/model/authentication_model/authentication_model.dart';
import 'package:world_wisdom/model/authentication_model/user_model/user.dart';
import 'package:world_wisdom/model/course_model/course_model.dart';
import 'package:world_wisdom/screen/constants/constants.dart';
import 'package:world_wisdom/screen/course_list/course_list_data.dart';
import 'package:world_wisdom/screen/key/key.dart';
import 'package:world_wisdom/screen/main_screen/main_app_bar/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:world_wisdom/widgets/horizontal_courses_list/horizontal_courses_list.dart';
import 'package:world_wisdom/widgets/horizontal_courses_list/horizontal_courses_list_header.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  CourseModel trendingCourse = CourseModel(courses: []);
  CourseModel newCourse = CourseModel(courses: []);
  CourseModel bestCourse = CourseModel(courses: []);
  CourseModel recommendedForYouCourse = CourseModel(courses: []);
  bool isLogged = false;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  Future<CourseModel> fetchTrendingCourseData(int limit, int page) async {
    var response = await http.post("${Constants.apiUrl}/course/top-sell",
        body: jsonEncode({"limit": limit, "page": page}),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      print(response.body);
      return CourseModel.fromJson(jsonDecode(response.body));
    }
    return CourseModel(courses: []);
  }

  Future<CourseModel> fetchTopNewCourseData(int limit, int page) async {
    var response = await http.post("${Constants.apiUrl}/course/top-new",
        body: jsonEncode({"limit": limit, "page": page}),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      print(response.body);
      return CourseModel.fromJson(jsonDecode(response.body));
    }
    return CourseModel(courses: []);
  }

  Future<CourseModel> fetchTopRateCourseData(int limit, int page) async {
    var response = await http.post("${Constants.apiUrl}/course/top-rate",
        body: jsonEncode({"limit": limit, "page": page}),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      print(response.body);
      return CourseModel.fromJson(jsonDecode(response.body));
    }
    return CourseModel(courses: []);
  }

  Future<CourseModel> fetchRecommendedCourseData(
      User user, int limit, int page) async {
    var response = await http.get(
        "${Constants.apiUrl}/user/recommend-course/${user.id}/$limit/$page");
    if (response.statusCode == 200) {
      print("Recommended - ${response.body}");
      return CourseModel.fromJson(jsonDecode(response.body));
    }
    return CourseModel(courses: []);
  }

  @override
  Widget build(BuildContext context) {
    isLogged = context.select((AuthenticationModel model) => model.isLoggedIn);
    var user = context.select((AuthenticationModel model) => model.user);

    if (isLogged && isLoaded == false) {
      isLoaded = true;
      fetchTrendingCourseData(4, 1).then((value) {
        setState(() {
          trendingCourse = value;
        });
      });
      fetchTopNewCourseData(4, 1).then((value) {
        setState(() {
          newCourse = value;
        });
      });

      fetchTopRateCourseData(4, 1).then((value) {
        setState(() {
          bestCourse = value;
        });
      });

      fetchRecommendedCourseData(user, 4, 1).then((value) {
        setState(() {
          recommendedForYouCourse = value;
        });
      });
    }

    return Scaffold(
      appBar: MainTabAppBar("Home"),
      body: isLogged
          ? Container(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                children: [
                  Column(
                    children: [
                      HorizontalCoursesListHeader("Trending", () {
                        CourseListData data =
                            CourseListData("Trending", fetchTrendingCourseData);
                        Keys.mainNavigatorKey.currentState
                            .pushNamed("/course-list", arguments: data);
                      }),
                      HorizontalCoursesList(trendingCourse),
                      HorizontalCoursesListHeader("Top new", () {
                        CourseListData data =
                            CourseListData("Top new", fetchTopNewCourseData);
                        Keys.mainNavigatorKey.currentState
                            .pushNamed("/course-list", arguments: data);
                      }),
                      HorizontalCoursesList(newCourse),
                      HorizontalCoursesListHeader("Top rate", () {
                        CourseListData data =
                            CourseListData("Top rate", fetchTopRateCourseData);
                        Keys.mainNavigatorKey.currentState
                            .pushNamed("/course-list", arguments: data);
                      }),
                      HorizontalCoursesList(bestCourse),
                      HorizontalCoursesListHeader("Recommended for you", () {
                        CourseListData data = CourseListData(
                            "Recommended for you", (limit, page) {
                          return fetchRecommendedCourseData(user, limit, page);
                        });
                        Keys.mainNavigatorKey.currentState
                            .pushNamed("/course-list", arguments: data);
                      }),
                      HorizontalCoursesList(recommendedForYouCourse),
                    ],
                  ),
                ],
              ),
            )
          : Container(
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 80, bottom: 20),
                    child: Text(
                      "Let's get you started",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
