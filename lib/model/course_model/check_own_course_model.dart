// To parse this JSON data, do
//
//     final checkOwnCourseModel = checkOwnCourseModelFromJson(jsonString);

import 'dart:convert';

CheckOwnCourseModel checkOwnCourseModelFromJson(String str) =>
    CheckOwnCourseModel.fromJson(json.decode(str));

String checkOwnCourseModelToJson(CheckOwnCourseModel data) =>
    json.encode(data.toJson());

class CheckOwnCourseModel {
  CheckOwnCourseModel({
    this.message,
    this.payload,
  });

  String message;
  OwnCourseStatus payload;

  factory CheckOwnCourseModel.fromJson(Map<String, dynamic> json) =>
      CheckOwnCourseModel(
        message: json["message"],
        payload: OwnCourseStatus.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "payload": payload.toJson(),
      };
}

class OwnCourseStatus {
  OwnCourseStatus({
    this.isUserOwnCourse,
    this.isInstructorOwnCourse,
  });

  bool isUserOwnCourse;
  bool isInstructorOwnCourse;

  factory OwnCourseStatus.fromJson(Map<String, dynamic> json) =>
      OwnCourseStatus(
        isUserOwnCourse: json["isUserOwnCourse"],
        isInstructorOwnCourse: json["isInstructorOwnCourse"],
      );

  Map<String, dynamic> toJson() => {
        "isUserOwnCourse": isUserOwnCourse,
        "isInstructorOwnCourse": isInstructorOwnCourse,
      };
}
