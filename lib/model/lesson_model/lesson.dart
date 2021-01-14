import 'package:world_wisdom/model/exercise_model/exercise.dart';
import 'package:world_wisdom/model/video_progress_model/video_progress_model.dart';

class Lesson {
  Lesson(
      {this.id,
      this.courseId,
      this.sectionId,
      this.numberOrder,
      this.name,
      this.content,
      this.videoName,
      this.videoUrl,
      this.captionName,
      this.hours,
      this.isPreview,
      this.isPublic,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.currentProgress,
      this.exercises});

  String id;
  String courseId;
  String sectionId;
  int numberOrder;
  String name;
  String content;
  dynamic videoName;
  String videoUrl;
  dynamic captionName;
  double hours;
  bool isPreview;
  bool isPublic;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  VideoProgression currentProgress;
  List<Exercise> exercises;

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
      id: json["id"],
      courseId: json["courseId"],
      sectionId: json["sectionId"],
      numberOrder: json["numberOrder"],
      name: json["name"],
      content: json["content"],
      videoName: json["videoName"],
      videoUrl: json["videoUrl"],
      captionName: json["captionName"],
      hours: json["hours"].toDouble(),
      isPreview: json["isPreview"],
      isPublic: json["isPublic"],
      isDeleted: json["isDeleted"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      currentProgress: json["currentProgress"] == null
          ? null
          : VideoProgression.fromJson(json["currentProgress"]),
      exercises: json["exercises"] == null
          ? null
          : List<Exercise>.from(
              json["exercises"].map((x) => Exercise.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "id": id,
        "courseId": courseId,
        "sectionId": sectionId,
        "numberOrder": numberOrder,
        "name": name,
        "content": content,
        "videoName": videoName,
        "videoUrl": videoUrl,
        "captionName": captionName,
        "hours": hours,
        "isPreview": isPreview,
        "isPublic": isPublic,
        "isDeleted": isDeleted,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "currentProgress": currentProgress,
        "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
      };
}
