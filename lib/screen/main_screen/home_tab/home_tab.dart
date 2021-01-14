import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import 'package:world_wisdom/generated/l10n.dart';
import 'package:world_wisdom/model/authentication_model/authentication_model.dart';
import 'package:world_wisdom/model/authentication_model/user_model/user.dart';
import 'package:world_wisdom/model/course_model/course.dart';
import 'package:world_wisdom/model/course_model/course_model.dart';
import 'package:world_wisdom/model/course_model/favorite_courses/favorite_courses_model.dart';
import 'package:world_wisdom/model/course_model/my_courses/my_courses_model.dart';
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
  Course selectedCourse;
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

  Future<CourseModel> fetchMyCoursesData(String token) async {
    var response = await http.get("${Constants.apiUrl}/payment", headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    });
    print(response.body);
    if (response.statusCode == 200) {
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

  void onCourseDetailTap(Course course) async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationModel authenticationModel =
        Provider.of<AuthenticationModel>(context);
    FavoriteCoursesModel favoriteCourseModel =
        Provider.of<FavoriteCoursesModel>(context);
    MyCoursesModel myCoursesModel = Provider.of<MyCoursesModel>(context);

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
        favoriteCourseModel.setCourseModel(value);
      });
      fetchMyCoursesData(authenticationModel.token).then((value) {
        myCoursesModel.setCourseModel(value);
      });
    }

    return Scaffold(
      appBar: MainTabAppBar(S.of(context).home),
      body: authenticationModel.isLoggedIn
          ? Container(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                children: [
                  Column(
                    children: [
                      HorizontalCoursesListHeader(S.of(context).trending, () {
                        CourseListData data = CourseListData(
                            S.of(context).trending, fetchTrendingCourseData);
                        Keys.mainNavigatorKey.currentState
                            .pushNamed("/course-list", arguments: data);
                      }),
                      HorizontalCoursesList(trendingCourse.courses),
                      HorizontalCoursesListHeader(S.of(context).topNew, () {
                        CourseListData data = CourseListData(
                            S.of(context).topNew, fetchTopNewCourseData);
                        Keys.mainNavigatorKey.currentState
                            .pushNamed("/course-list", arguments: data);
                      }),
                      HorizontalCoursesList(newCourse.courses),
                      HorizontalCoursesListHeader(S.of(context).topRate, () {
                        CourseListData data = CourseListData(
                            S.of(context).topRate, fetchTopRateCourseData);
                        Keys.mainNavigatorKey.currentState
                            .pushNamed("/course-list", arguments: data);
                      }),
                      HorizontalCoursesList(bestCourse.courses),
                      HorizontalCoursesListHeader(
                          S.of(context).recommendedForYou, () {
                        CourseListData data = CourseListData(
                            S.of(context).recommendedForYou, (limit, page) {
                          return fetchRecommendedCourseData(
                              authenticationModel.user, limit, page);
                        });
                        Keys.mainNavigatorKey.currentState
                            .pushNamed("/course-list", arguments: data);
                      }),
                      HorizontalCoursesList(recommendedForYouCourse.courses),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            S.of(context).favorite,
                            style: Theme.of(context).textTheme.headline6,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      HorizontalCoursesList(favoriteCourseModel.courses),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            S.of(context).myCourses,
                            style: Theme.of(context).textTheme.headline6,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      HorizontalCoursesList(myCoursesModel.courses),
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
                        S.of(context).homeHint,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.apps_outlined,
                        ),
                        onPressed: () {
                          BottomNavigationBar bottomNavigationBar =
                              Keys.bottomNavigationBarKey.currentWidget;
                          bottomNavigationBar.onTap(2);
                        }),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 30),
                      child: Text(
                        S.of(context).browseHint,
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.search,
                        ),
                        onPressed: () {
                          BottomNavigationBar bottomNavigationBar =
                              Keys.bottomNavigationBarKey.currentWidget;
                          bottomNavigationBar.onTap(3);
                        }),
                    Container(
                      margin: EdgeInsets.only(top: 5, bottom: 20),
                      child: Text(
                        S.of(context).searchHint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
