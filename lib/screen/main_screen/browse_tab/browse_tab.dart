import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:world_wisdom/generated/l10n.dart';
import 'package:world_wisdom/model/authentication_model/authentication_model.dart';
import 'package:world_wisdom/model/category_model/category.dart';
import 'package:world_wisdom/model/category_model/category_model.dart';
import 'package:world_wisdom/model/course_model/course_model.dart';
import 'package:world_wisdom/model/search_model/search_form.dart';
import 'package:world_wisdom/model/search_model/search_response.dart';
import 'package:world_wisdom/screen/constants/constants.dart';
import 'package:world_wisdom/screen/course/course_list/course_list_data.dart';
import 'package:world_wisdom/screen/key/key.dart';
import 'package:world_wisdom/screen/main_screen/main_app_bar/main_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:world_wisdom/widgets/horizontal_courses_list/horizontal_courses_list.dart';
import 'package:world_wisdom/widgets/horizontal_courses_list/horizontal_courses_list_header.dart';

class BrowseTab extends StatefulWidget {
  @override
  _BrowseTabState createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  CategoryModel categoryModel = CategoryModel(categories: []);
  Map<String, CourseModel> coursesMap = {};
  bool isLogged = false;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchCategoryData() async {
    var response = await http.get("${Constants.apiUrl}/category/all");
    if (response.statusCode == 200) {
      setState(() {
        categoryModel = CategoryModel.fromJson(jsonDecode(response.body));
      });
      for (var category in categoryModel.categories) {
        var courseModel = CourseModel(courses: []);
        coursesMap[category.id] = courseModel;
        fetchCourseFormCategory(category.id, 4, 0).then((value) {
          setState(() {
            courseModel.courses.addAll(value.courses);
          });
        });
      }
      isLoaded = true;
    }
  }

  Future<CourseModel> fetchCourseFormCategory(
      String id, int limit, int page) async {
    SearchForm searchForm = SearchForm.empty();
    searchForm.opt.category.add(id);
    searchForm.limit = limit;
    searchForm.offset = page;
    print(searchForm.toJson());
    var response = await http.post("${Constants.apiUrl}/course/search",
        body: jsonEncode(searchForm.toJson()),
        headers: {"Content-Type": "application/json"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      SearchResponse searchResponse =
          SearchResponse.fromJson(jsonDecode(response.body));
      return searchResponse.courseModel;
    } else {
      return CourseModel(courses: []);
    }
  }

  @override
  Widget build(BuildContext context) {
    isLogged = context.select((AuthenticationModel model) => model.isLoggedIn);
    if (isLoaded == false) {
      fetchCategoryData();
    }

    return Scaffold(
      appBar: MainTabAppBar(S.of(context).browse),
      body: ListView.builder(
          itemCount: categoryModel.categories.length + 1,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          itemBuilder: (context, index) {
            if (index == 0) {
              if (isLogged == false)
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        index == 0
                            ? Container(
                                margin: EdgeInsets.symmetric(vertical: 3),
                                child: Text(
                                  S.of(context).signInHint,
                                  style: Theme.of(context).textTheme.headline6,
                                  textAlign: TextAlign.left,
                                ),
                              )
                            : SizedBox(),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            S.of(context).browseEncourage,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(right: 20),
                          child: ElevatedButton(
                              onPressed: () {
                                Keys.appNavigationKey.currentState
                                    .pushNamed("/authentication/login");
                              },
                              child: Text(
                                S.of(context).signInNavigateButtonText,
                                style: Theme.of(context).textTheme.button,
                              )),
                        ),
                      ]),
                );
              else
                return SizedBox();
            }
            index--;
            Category category = categoryModel.categories[index];
            return Column(
              children: [
                HorizontalCoursesListHeader(category.name, () {
                  CourseListData data =
                      CourseListData(category.name, (limit, page) {
                    return fetchCourseFormCategory(category.id, limit, page);
                  });
                  Keys.mainNavigatorKey.currentState
                      .pushNamed("/course-list", arguments: data);
                }),
                HorizontalCoursesList(coursesMap[category.id] != null
                    ? coursesMap[category.id].courses
                    : [])
              ],
            );
          }),
    );
  }
}
