import 'package:flutter/cupertino.dart';
import 'package:world_wisdom/model/course_model/course.dart';

class CourseModel {
  CourseModel({
    this.courses,
  });

  List<Course> courses = [];

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        courses: List<Course>.from(json["rows"] != null
            ? json["rows"].map((x) => Course.fromJson(x))
            : json["payload"].map((x) => Course.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rows": List<dynamic>.from(courses.map((x) => x.toJson())),
      };
}
