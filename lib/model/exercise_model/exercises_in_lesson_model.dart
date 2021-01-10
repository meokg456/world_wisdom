// To parse this JSON data, do
//
//     final exercisesInLessonModel = exercisesInLessonModelFromJson(jsonString);

import 'dart:convert';

import 'package:world_wisdom/model/exercise_model/exercise.dart';

ExercisesInLessonModel exercisesInLessonModelFromJson(String str) =>
    ExercisesInLessonModel.fromJson(json.decode(str));

String exercisesInLessonModelToJson(ExercisesInLessonModel data) =>
    json.encode(data.toJson());

class ExercisesInLessonModel {
  ExercisesInLessonModel({
    this.message,
    this.payload,
  });

  String message;
  ExercisesListModel payload;

  factory ExercisesInLessonModel.fromJson(Map<String, dynamic> json) =>
      ExercisesInLessonModel(
        message: json["message"],
        payload: ExercisesListModel.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "payload": payload.toJson(),
      };
}

class ExercisesListModel {
  ExercisesListModel({
    this.exercises,
  });

  List<Exercise> exercises;

  factory ExercisesListModel.fromJson(Map<String, dynamic> json) =>
      ExercisesListModel(
        exercises: List<Exercise>.from(
            json["exercises"].map((x) => Exercise.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
      };
}
