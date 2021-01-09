// To parse this JSON data, do
//
//     final searchV2Form = searchV2FormFromJson(jsonString);

import 'package:world_wisdom/model/course_model/course.dart';

class SearchV2Response {
  SearchV2Response({
    this.message,
    this.payload,
  });

  String message;
  Payload payload;

  factory SearchV2Response.fromJson(Map<String, dynamic> json) =>
      SearchV2Response(
        message: json["message"],
        payload: Payload.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "payload": payload.toJson(),
      };
}

class Payload {
  Payload({
    this.courses,
    this.instructors,
  });

  Courses courses;
  Instructors instructors;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        courses: Courses.fromJson(json["courses"]),
        instructors: Instructors.fromJson(json["instructors"]),
      );

  Map<String, dynamic> toJson() => {
        "courses": courses.toJson(),
        "instructors": instructors.toJson(),
      };
}

class Courses {
  Courses({
    this.data,
    this.totalInPage,
    this.total,
  });

  List<Course> data;
  int totalInPage;
  int total;

  factory Courses.fromJson(Map<String, dynamic> json) => Courses(
        data: List<Course>.from(json["data"].map((x) => Course.fromJson(x))),
        totalInPage: json["totalInPage"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalInPage": totalInPage,
        "total": total,
      };
}

class Instructors {
  Instructors({
    this.data,
    this.totalInPage,
    this.total,
  });

  List<InstructorData> data;
  int totalInPage;
  int total;

  factory Instructors.fromJson(Map<String, dynamic> json) => Instructors(
        data: List<InstructorData>.from(
            json["data"].map((x) => InstructorData.fromJson(x))),
        totalInPage: json["totalInPage"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalInPage": totalInPage,
        "total": total,
      };
}

class InstructorData {
  InstructorData({
    this.id,
    this.name,
    this.avatar,
    this.numCourses,
  });

  String id;
  String name;
  String avatar;
  String numCourses;

  factory InstructorData.fromJson(Map<String, dynamic> json) => InstructorData(
        id: json["id"],
        name: json["name"],
        avatar: json["avatar"],
        numCourses: json["numcourses"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "avatar": avatar,
        "numcourses": numCourses,
      };
}
