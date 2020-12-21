import 'package:world_wisdom/model/course.dart';

class CourseModel {
  CourseModel({
    this.courses,
    this.count,
  });

  List<Course> courses;
  int count;

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        courses: List<Course>.from(json["rows"].map((x) => Course.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "rows": List<dynamic>.from(courses.map((x) => x.toJson())),
        "count": count,
      };
}
