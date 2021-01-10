import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:world_wisdom/model/authentication_model/authentication_model.dart';
import 'package:world_wisdom/model/authentication_model/user_model/user.dart';
import 'package:world_wisdom/model/course_model/course_model.dart';
import 'package:world_wisdom/screen/constants/constants.dart';
import 'package:world_wisdom/screen/course/course_list/course_list_data.dart';
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
  CourseModel favoriteCourse = CourseModel(courses: []);
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

  Future<CourseModel> fetchFavoriteCoursesData(String token) async {
    var response = await http
        .get("${Constants.apiUrl}/user/get-favorite-courses", headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    });
    print(response.body);
    if (response.statusCode == 200) {
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
    AuthenticationModel authenticationModel =
        Provider.of<AuthenticationModel>(context);
    favoriteCourse = Provider.of<CourseModel>(context);

    if (authenticationModel.isLoggedIn && isLoaded == false) {
      isLoaded = true;
      fetchTrendingCourseData(4, 0).then((value) {
        setState(() {
          trendingCourse = value;
        });
      });
      fetchTopNewCourseData(4, 0).then((value) {
        setState(() {
          newCourse = value;
        });
      });

      fetchTopRateCourseData(4, 0).then((value) {
        setState(() {
          bestCourse = value;
        });
      });

      fetchRecommendedCourseData(authenticationModel.user, 4, 0).then((value) {
        setState(() {
          recommendedForYouCourse = value;
        });
      });
      fetchFavoriteCoursesData(authenticationModel.token).then((value) {
        favoriteCourse.setCourseModel(value);
      });
    }

    return Scaffold(
      appBar: MainTabAppBar("Home"),
      body: authenticationModel.isLoggedIn
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
                          return fetchRecommendedCourseData(
                              authenticationModel.user, limit, page);
                        });
                        Keys.mainNavigatorKey.currentState
                            .pushNamed("/course-list", arguments: data);
                      }),
                      HorizontalCoursesList(recommendedForYouCourse),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Favorite",
                            style: Theme.of(context).textTheme.headline6,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      HorizontalCoursesList(favoriteCourse),
                    ],
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 80, bottom: 20),
                      child: Text(
                        "Let's get you started",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
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
            ),
    );
  }
}
