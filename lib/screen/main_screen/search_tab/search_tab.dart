import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:world_wisdom/generated/l10n.dart';
import 'package:world_wisdom/model/authentication_model/authentication_model.dart';
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
        search(searchTextFieldController.text, token, limit, ++page)
            .then((result) {
          setState(() {
            courses.addAll(result.payload.courses.data);
            totalCourses = result.payload.courses.total;
            totalInstructors = result.payload.instructors.total;
            isFocus = false;
            isLoaded = false;
          });
        });
      }
    });
    instructorsListScrollController.addListener(() {
      if (instructorsListScrollController.offset ==
          instructorsListScrollController.position.maxScrollExtent) {
        search(searchTextFieldController.text, token, limit, ++page)
            .then((result) {
          setState(() {
            instructors.addAll(result.payload.instructors.data);
            totalCourses = result.payload.courses.total;
            totalInstructors = result.payload.instructors.total;
            isFocus = false;
            isLoaded = false;
          });
        });
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

  Future<SearchV2Response> search(
      String keyword, String token, int limit, int page) async {
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
      return SearchV2Response.fromJson(jsonDecode(response.body));
    }
    return null;
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
          S.of(context).courses,
          style: Theme.of(context).textTheme.headline5,
        ),
        trailing: TextButton(
          onPressed: () {
            tabController.index = 1;
          },
          child: Text(
            "$totalCourses ${S.of(context).results} >",
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ));
      tabAllWidgets.add(Divider());
      tabCoursesWidgets.add(ListTile(
        title: Text(
          "$totalCourses ${S.of(context).results}",
          style: Theme.of(context).textTheme.caption,
        ),
        trailing: Text(
          S.of(context).cheapest,
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
                "${S.of(context).coursesNotFound} \"${searchTextFieldController.text}\"",
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
          S.of(context).instructors,
          style: Theme.of(context).textTheme.headline5,
        ),
        trailing: TextButton(
          child: Text(
            "$totalInstructors ${S.of(context).results} >",
            style: Theme.of(context).textTheme.caption,
          ),
          onPressed: () {
            tabController.index = 2;
          },
        ),
      ));
      tabAuthorsWidgets.add(ListTile(
        title: Text(
          "$totalInstructors ${S.of(context).results}",
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
                "${S.of(context).instructorsNotFound} \"${searchTextFieldController.text}\"",
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
            search(text, token, limit, page).then((result) {
              setState(() {
                courses = result.payload.courses.data;
                instructors = result.payload.instructors.data;
                totalCourses = result.payload.courses.total;
                totalInstructors = result.payload.instructors.total;
                isFocus = false;
                isLoaded = false;
              });
            });
          },
          decoration: InputDecoration(
              hintText: "${S.of(context).search}...",
              prefixIcon: Icon(
                Icons.search,
                color: isFocus ? Theme.of(context).accentColor : Colors.black87,
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: isFocus
                          ? Theme.of(context).accentColor
                          : Colors.black87)),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  color:
                      isFocus ? Theme.of(context).accentColor : Colors.black87,
                ),
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
                tabs: [
                  Text(S.of(context).all),
                  Text(S.of(context).courses),
                  Text(S.of(context).instructors)
                ],
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
                    search(searchHistory.content, token, limit, page)
                        .then((result) {
                      setState(() {
                        courses = result.payload.courses.data;
                        instructors = result.payload.instructors.data;
                        totalCourses = result.payload.courses.total;
                        totalInstructors = result.payload.instructors.total;
                        isFocus = false;
                        isLoaded = false;
                      });
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
