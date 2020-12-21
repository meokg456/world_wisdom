import 'package:world_wisdom/model/course_model.dart';

class SearchResponse {
  SearchResponse({
    this.message,
    this.courseModel,
  });

  String message;
  CourseModel courseModel;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        message: json["message"],
        courseModel: CourseModel.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "payload": courseModel.toJson(),
      };
}
