import 'package:world_wisdom/model/course_model/course_detail.dart';

class CourseDetailModel {
  CourseDetailModel({
    this.message,
    this.payload,
  });

  String message;
  CourseDetail payload;

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) =>
      CourseDetailModel(
        message: json["message"],
        payload: CourseDetail.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "payload": payload.toJson(),
      };
}
