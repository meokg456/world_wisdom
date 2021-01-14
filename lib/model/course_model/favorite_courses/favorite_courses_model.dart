import 'package:flutter/material.dart';
import 'package:world_wisdom/model/course_model/course.dart';
import 'package:world_wisdom/model/course_model/course_model.dart';

class FavoriteCoursesModel extends ChangeNotifier {
  List<Course> courses = [];
  void add(Course course) {
    courses.add(course);
    notifyListeners();
  }

  void remove(String id) {
    courses.removeWhere((course) => course.id == id);
    notifyListeners();
  }

  void setCourseModel(CourseModel courseModel) {
    this.courses = courseModel.courses;
    notifyListeners();
  }
}
