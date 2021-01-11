import 'package:flutter/material.dart';
import 'package:world_wisdom/model/course_model/course.dart';
import 'package:world_wisdom/model/course_model/course_model.dart';
import 'package:world_wisdom/widgets/horizontal_courses_list/horizontal_courses_list_item.dart';

class HorizontalCoursesList extends StatelessWidget {
  final CourseModel courseModel;

  HorizontalCoursesList(this.courseModel);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 220,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: courseModel.courses.length,
            itemBuilder: (context, index) {
              Course course = courseModel.courses[index];
              return HorizontalCoursesListItem(course);
            }));
  }
}
