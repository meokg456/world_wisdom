import 'package:world_wisdom/model/lesson_model/lesson.dart';

class Section {
  Section({
    this.id,
    this.courseId,
    this.numberOrder,
    this.name,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.lesson,
    this.sumHours,
    this.sumLessonFinish,
  });

  String id;
  String courseId;
  int numberOrder;
  String name;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  List<Lesson> lesson;
  double sumHours;
  int sumLessonFinish;
  bool isExpanded = false;

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        id: json["id"],
        courseId: json["courseId"],
        numberOrder: json["numberOrder"],
        name: json["name"],
        isDeleted: json["isDeleted"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        lesson:
            List<Lesson>.from(json["lesson"].map((x) => Lesson.fromJson(x))),
        sumHours: json["sumHours"].toDouble(),
        sumLessonFinish: json["sumLessonFinish"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "courseId": courseId,
        "numberOrder": numberOrder,
        "name": name,
        "isDeleted": isDeleted,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "lesson": List<dynamic>.from(lesson.map((x) => x.toJson())),
        "sumHours": sumHours,
        "sumLessonFinish": sumLessonFinish,
      };
}
