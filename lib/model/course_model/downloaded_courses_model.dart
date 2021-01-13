import 'package:flutter/cupertino.dart';
import 'package:world_wisdom/model/course_model/course_detail.dart';

class DownloadedCoursesModel extends ChangeNotifier {
  List<CourseDetail> courses = [];

  void add(CourseDetail courseDetail) {
    courses.add(courseDetail);
    notifyListeners();
  }

  void addAll(List<CourseDetail> courses) {
    courses.addAll(courses);
    notifyListeners();
  }
}
