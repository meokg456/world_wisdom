// To parse this JSON data, do
//
//     final lastWatchedModel = lastWatchedModelFromJson(jsonString);

import 'dart:convert';

LastWatchedLessonModel lastWatchedModelFromJson(String str) =>
    LastWatchedLessonModel.fromJson(json.decode(str));

String lastWatchedModelToJson(LastWatchedLessonModel data) =>
    json.encode(data.toJson());

class LastWatchedLessonModel {
  LastWatchedLessonModel({
    this.message,
    this.payload,
  });

  String message;
  LastWatchedLesson payload;

  factory LastWatchedLessonModel.fromJson(Map<String, dynamic> json) =>
      LastWatchedLessonModel(
        message: json["message"],
        payload: LastWatchedLesson.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "payload": payload.toJson(),
      };
}

class LastWatchedLesson {
  LastWatchedLesson({
    this.lessonId,
    this.videoUrl,
    this.currentTime,
    this.isFinish,
  });

  String lessonId;
  String videoUrl;
  double currentTime;
  bool isFinish;

  factory LastWatchedLesson.fromJson(Map<String, dynamic> json) =>
      LastWatchedLesson(
        lessonId: json["lessonId"],
        videoUrl: json["videoUrl"],
        currentTime: json["currentTime"].toDouble(),
        isFinish: json["isFinish"],
      );

  Map<String, dynamic> toJson() => {
        "lessonId": lessonId,
        "videoUrl": videoUrl,
        "currentTime": currentTime,
        "isFinish": isFinish,
      };
}
