import 'package:world_wisdom/model/course_model/course_model.dart';

class CourseListData {
  String title;
  Future<CourseModel> Function(int, int) fetchDataFunction;

  CourseListData(this.title, this.fetchDataFunction);
}
