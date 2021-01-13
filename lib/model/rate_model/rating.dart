import 'package:world_wisdom/model/authentication_model/user_model/user.dart';

class Rating {
  Rating({
    this.id,
    this.userId,
    this.courseId,
    this.formalityPoint,
    this.contentPoint,
    this.presentationPoint,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.averagePoint,
  });

  String id;
  String userId;
  String courseId;
  double formalityPoint;
  double contentPoint;
  double presentationPoint;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  double averagePoint;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        id: json["id"],
        userId: json["userId"],
        courseId: json["courseId"],
        formalityPoint: json["formalityPoint"].toDouble(),
        contentPoint: json["contentPoint"].toDouble(),
        presentationPoint: json["presentationPoint"].toDouble(),
        content: json["content"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        averagePoint: json["averagePoint"] == null
            ? null
            : json["averagePoint"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "courseId": courseId,
        "formalityPoint": formalityPoint,
        "contentPoint": contentPoint,
        "presentationPoint": presentationPoint,
        "content": content,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "user": user.toJson(),
        "averagePoint": averagePoint,
      };

  Map<String, dynamic> toRateSubmitJson() => {
        "courseId": courseId,
        "formalityPoint": formalityPoint,
        "contentPoint": contentPoint,
        "presentationPoint": presentationPoint,
        "content": content,
      };
}
