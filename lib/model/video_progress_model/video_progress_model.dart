// To parse this JSON data, do
//
//     final videoProgressModel = videoProgressModelFromJson(jsonString);

import 'dart:convert';

VideoProgressModel videoProgressModelFromJson(String str) =>
    VideoProgressModel.fromJson(json.decode(str));

String videoProgressModelToJson(VideoProgressModel data) =>
    json.encode(data.toJson());

class VideoProgressModel {
  VideoProgressModel({
    this.message,
    this.payload,
  });

  String message;
  VideoProgression payload;

  factory VideoProgressModel.fromJson(Map<String, dynamic> json) =>
      VideoProgressModel(
        message: json["message"],
        payload: VideoProgression.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "payload": payload.toJson(),
      };
}

class VideoProgression {
  VideoProgression({
    this.videoUrl,
    this.currentTime,
    this.isFinish,
  });

  String videoUrl;
  double currentTime;
  bool isFinish;

  factory VideoProgression.fromJson(Map<String, dynamic> json) =>
      VideoProgression(
        videoUrl: json["videoUrl"],
        currentTime:
            json["currentTime"] == null ? 0 : json["currentTime"].toDouble(),
        isFinish: json["isFinish"],
      );

  Map<String, dynamic> toJson() => {
        "videoUrl": videoUrl,
        "currentTime": currentTime,
        "isFinish": isFinish,
      };
}
