import 'package:flutter/material.dart';
import 'package:world_wisdom/model/course_model/course.dart';
import 'package:world_wisdom/model/course_model/course_model.dart';
import 'package:world_wisdom/screen/course/course_list/course_list_data.dart';
import 'package:world_wisdom/widgets/vertical_courses_list/vertical_courses_item.dart';

enum MenuItem { download, share }

class CourseListScreen extends StatefulWidget {
  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  CourseModel courseModel = CourseModel(courses: []);
  CourseListData courseListData;
  bool isLoaded = false;
  ScrollController scrollController = ScrollController();
  int currentPage = 0;
  int limit = 10;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        currentPage++;
        courseListData.fetchDataFunction(limit, currentPage).then((value) {
          setState(() {
            courseModel.courses.addAll(value.courses);
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    courseListData = ModalRoute.of(context).settings.arguments;
    if (!isLoaded) {
      isLoaded = true;
      courseListData.fetchDataFunction(limit, currentPage).then((value) {
        setState(() {
          courseModel.courses.addAll(value.courses);
        });
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(courseListData.title),
        centerTitle: true,
      ),
      body: Container(
        child: ListView.separated(
          controller: scrollController,
          padding: EdgeInsets.symmetric(vertical: 50),
          itemCount: courseModel.courses.length,
          itemBuilder: (context, index) {
            Course course = courseModel.courses[index];
            return VerticalCoursesListItem(course);
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ),
      ),
    );
  }
}
