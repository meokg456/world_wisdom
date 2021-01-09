import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:world_wisdom/model/authentication_model/authentication_model.dart';
import 'package:world_wisdom/model/authentication_model/user_model/user_model.dart';
import 'package:world_wisdom/model/course_model/course.dart';
import 'package:world_wisdom/model/search_v2_model/search_history.dart';
import 'package:world_wisdom/model/search_v2_model/search_history_model.dart';
import 'package:world_wisdom/model/search_v2_model/search_v2_form.dart';
import 'package:http/http.dart' as http;
import 'package:world_wisdom/model/search_v2_model/search_v2_response.dart';
import 'package:world_wisdom/screen/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:world_wisdom/widgets/vertical_courses_list/vertical_courses_item.dart';
import 'package:world_wisdom/widgets/vertical_instructors_list/vertical_instuctors_list_item.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab>
    with SingleTickerProviderStateMixin {
  TextEditingController searchTextFieldController = TextEditingController();

  ScrollController coursesListScrollController = ScrollController();
  ScrollController instructorsListScrollController = ScrollController();

  bool isFocus = true;
  bool isLoaded = false;
  int totalCourses = 0;
  int totalInstructors = 0;
  List<Course> courses = [];
  List<InstructorData> instructors = [];
  List<SearchHistory> history = [];
  int limit = 10;
  int page = 0;
  TabController tabController;
  String token = "";

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    coursesListScrollController.addListener(() {
      if (coursesListScrollController.offset ==
          coursesListScrollController.position.maxScrollExtent) {
        search(searchTextFieldController.text, token, limit, ++page);
      }
    });
    instructorsListScrollController.addListener(() {
      if (instructorsListScrollController.offset ==
          instructorsListScrollController.position.maxScrollExtent) {
        search(searchTextFieldController.text, token, limit, ++page);
      }
    });
    tabController.addListener(() {
      if (tabController.previousIndex != tabController.index) {
        setState(() {});
      }
    });
  }

  void fetchHistory(String token) async {
    var response = await http.get("${Constants.apiUrl}/course/search-history",
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });
    print(response.body);
    if (response.statusCode == 200) {
      SearchHistoryModel searchHistoryModel =
          SearchHistoryModel.fromJson(jsonDecode(response.body));
      setState(() {
        history = searchHistoryModel.payload.searchHistory;
      });
    }
  }

  void search(String keyword, String token, int limit, int page) async {
    SearchV2Form searchForm = SearchV2Form.empty();
    searchForm.keyword = keyword;
    searchForm.token = token;
    searchForm.limit = limit;
    searchForm.offset = page;
    print(searchForm.toJson());
    var response = await http.post("${Constants.apiUrl}/course/searchV2",
        body: jsonEncode(searchForm.toJson()),
        headers: {"Content-Type": "application/json"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      SearchV2Response searchResponse =
          SearchV2Response.fromJson(jsonDecode(response.body));
      setState(() {
        courses.addAll(searchResponse.payload.courses.data);
        instructors.addAll(searchResponse.payload.instructors.data);
        totalCourses = searchResponse.payload.courses.total;
        totalInstructors = searchResponse.payload.instructors.total;
      });
    }
  }

  void deleteSearchHistory(String id, String token) async {
    var response = await http.delete(
        "${Constants.apiUrl}/course/delete-search-history/$id",
        headers: {"Authorization": "Bearer $token"});
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        isLoaded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    token = context.select((AuthenticationModel value) => value.token);
    if (isFocus && !isLoaded) {
      isLoaded = true;
      fetchHistory(token);
    }
    List<Widget> tabAllWidgets = [];
    List<Widget> tabCoursesWidgets = [];
    List<Widget> tabAuthorsWidgets = [];
    if (!isFocus) {
      tabAllWidgets.add(ListTile(
        title: Text(
          "Courses",
          style: Theme.of(context).textTheme.headline5,
        ),
        trailing: TextButton(
          onPressed: () {
            tabController.index = 1;
          },
          child: Text(
            "$totalCourses results >",
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ));
      tabAllWidgets.add(Divider());
      tabCoursesWidgets.add(ListTile(
        title: Text(
          "$totalCourses results",
          style: Theme.of(context).textTheme.caption,
        ),
        trailing: Text(
          "Cheapest",
          style: Theme.of(context).textTheme.caption,
        ),
      ));
      if (courses.length == 0) {
        Widget emptyNotificationWidget = Column(
          children: [
            Icon(
              Icons.search,
              size: 50,
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: 200,
              child: Text(
                "Sorry, we couldn't find any course matches for \"${searchTextFieldController.text}\"",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
        tabAllWidgets.add(emptyNotificationWidget);
        tabCoursesWidgets.add(emptyNotificationWidget);
      }
      courses.forEach((course) {
        if (tabAllWidgets.length < 10) {
          tabAllWidgets.add(VerticalCoursesListItem(course));
          tabAllWidgets.add(Divider());
        }
        tabCoursesWidgets.add(VerticalCoursesListItem(course));
        tabCoursesWidgets.add(Divider());
      });
      tabAllWidgets.add(ListTile(
        title: Text(
          "Authors",
          style: Theme.of(context).textTheme.headline5,
        ),
        trailing: TextButton(
          child: Text(
            "$totalInstructors results >",
            style: Theme.of(context).textTheme.caption,
          ),
          onPressed: () {
            tabController.index = 2;
          },
        ),
      ));
      tabAuthorsWidgets.add(ListTile(
        title: Text(
          "$totalInstructors results",
          style: Theme.of(context).textTheme.caption,
        ),
      ));
      tabAllWidgets.add(Divider());
      if (instructors.length == 0) {
        Widget emptyNotificationWidget = Column(
          children: [
            Icon(
              Icons.search,
              size: 50,
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: 200,
              child: Text(
                "Sorry, we couldn't find any author matches for \"${searchTextFieldController.text}\"",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
        tabAllWidgets.add(emptyNotificationWidget);
        tabAuthorsWidgets.add(emptyNotificationWidget);
      }
      instructors.forEach((instructor) {
        if (tabAllWidgets.length < 20) {
          tabAllWidgets.add(VerticalInstructorsListItem(instructor));
          tabAllWidgets.add(Divider());
        }
        tabAuthorsWidgets.add(VerticalInstructorsListItem(instructor));
        tabAuthorsWidgets.add(Divider());
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchTextFieldController,
          enableSuggestions: true,
          onChanged: (text) {
            setState(() {
              isFocus = true;
            });
          },
          onSubmitted: (text) {
            courses = [];
            instructors = [];
            search(text, token, limit, page);
            setState(() {
              isFocus = false;
              isLoaded = false;
            });
          },
          decoration: InputDecoration(
              hintText: "Search...",
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  searchTextFieldController.text = "";
                  setState(() {
                    isFocus = true;
                    isLoaded = false;
                  });
                },
              )),
          autofocus: true,
        ),
        bottom: isFocus
            ? null
            : TabBar(
                controller: tabController,
                labelPadding: EdgeInsets.all(15),
                tabs: [Text("All"), Text("Courses"), Text("Authors")],
              ),
      ),
      body: isFocus
          ? ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                SearchHistory searchHistory = history[index];
                return ListTile(
                  onTap: () {
                    tabController.index = 0;
                    searchTextFieldController.text = searchHistory.content;
                    courses = [];
                    instructors = [];
                    search(searchHistory.content, token, limit, page);
                    setState(() {
                      isFocus = false;
                      isLoaded = false;
                    });
                  },
                  leading: Icon(Icons.history),
                  title: Text(searchHistory.content),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_forever_rounded),
                    onPressed: () {
                      deleteSearchHistory(searchHistory.id, token);
                    },
                  ),
                );
              })
          : TabBarView(
              controller: tabController,
              children: [
                ListView(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  children: tabAllWidgets,
                ),
                ListView(
                  controller: coursesListScrollController,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  children: tabCoursesWidgets,
                ),
                ListView(
                  controller: instructorsListScrollController,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  children: tabAuthorsWidgets,
                ),
              ],
            ),
    );
  }
}
