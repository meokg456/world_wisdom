import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:world_wisdom/model/authentication_model.dart';
import 'package:world_wisdom/model/category.dart';
import 'package:world_wisdom/model/category_model.dart';
import 'package:world_wisdom/model/course.dart';
import 'package:world_wisdom/model/course_model.dart';
import 'package:world_wisdom/model/search_form.dart';
import 'package:world_wisdom/model/search_response.dart';
import 'package:world_wisdom/screen/constants/constants.dart';
import 'package:world_wisdom/screen/key/key.dart';
import 'package:world_wisdom/screen/main_screen/main_app_bar/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  CategoryModel categoryModel = CategoryModel(categories: []);
  Map<String, CourseModel> coursesMap = {};
  bool isLogged = false;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchCategoryData() async {
    if (isLoaded) return;
    var response = await http.get("${Constants.apiUrl}/category/all");
    if (response.statusCode == 200) {
      setState(() {
        categoryModel = CategoryModel.fromJson(jsonDecode(response.body));
      });
      for (var category in categoryModel.categories) {
        fetchCourseFormCategory(category.id);
      }
      isLoaded = true;
    }
  }

  Future<void> fetchCourseFormCategory(String id) async {
    SearchForm searchForm = SearchForm.empty();
    searchForm.opt.category.add(id);
    print(searchForm.toJson());
    var response = await http.post("${Constants.apiUrl}/course/search",
        body: jsonEncode(searchForm.toJson()),
        headers: {"Content-Type": "application/json"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      SearchResponse searchResponse =
          SearchResponse.fromJson(jsonDecode(response.body));
      setState(() {
        coursesMap[id] = searchResponse.courseModel;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    isLogged = context.select((AuthenticationModel model) => model.isLoggedIn);
    if (isLogged) {
      fetchCategoryData();
    }

    return Scaffold(
      appBar: MainTabAppBar("Home"),
      body: isLogged
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: ListView.builder(
                  itemCount: categoryModel.categories.length,
                  itemBuilder: (context, index) {
                    Category category = categoryModel.categories[index];
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category.name,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            TextButton(
                                onPressed: () {}, child: Text("See all >"))
                          ],
                        ),
                        Container(
                          height: 220,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: coursesMap[category.id] == null
                                  ? 0
                                  : coursesMap[category.id].count,
                              itemBuilder: (context, index) {
                                Course course =
                                    coursesMap[category.id].courses[index];
                                return Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Card(
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width: 200,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.network(
                                              course.imageUrl,
                                              width: double.infinity,
                                              height: 100,
                                              fit: BoxFit.fill,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              course.title,
                                              overflow: TextOverflow.clip,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6,
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              course.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              course.price == 0
                                                  ? "Free"
                                                  : NumberFormat.currency(
                                                          locale: Localizations
                                                                  .localeOf(
                                                                      context)
                                                              .toString())
                                                      .format(course.price),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            RatingBar.builder(
                                              initialRating:
                                                  course.ratedNumber.toDouble(),
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 12,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 1),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              ignoreGestures: true,
                                              onRatingUpdate: (double value) {},
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    );
                  }),
              // child: ListView(
              //   children: [
              //     Column(
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               "Software Development",
              //               style: Theme.of(context).textTheme.headline6,
              //             ),
              //             TextButton(onPressed: () {}, child: Text("See all >"))
              //           ],
              //         ),
              //         Container(
              //           height: 100,
              //           child: ListView(
              //             scrollDirection: Axis.horizontal,
              //             children: [
              //               Card(
              //                 child: Column(
              //                   children: [],
              //                 ),
              //               )
              //             ],
              //           ),
              //         )
              //       ],
              //     )
              //   ],
              // ),
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
