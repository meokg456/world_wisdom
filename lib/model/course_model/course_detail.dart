import 'package:world_wisdom/model/course_model/course.dart';
import 'package:world_wisdom/model/course_model/course_like_category.dart';
import 'package:world_wisdom/model/instructor_model/instructor.dart';
import 'package:world_wisdom/model/rate_model/rating.dart';
import 'package:world_wisdom/model/section_model/section.dart';

class CourseDetail {
  CourseDetail({
    this.id,
    this.title,
    this.subtitle,
    this.price,
    this.description,
    this.requirement,
    this.learnWhat,
    this.soldNumber,
    this.ratedNumber,
    this.videoNumber,
    this.totalHours,
    this.formalityPoint,
    this.contentPoint,
    this.presentationPoint,
    this.imageUrl,
    this.promoVidUrl,
    this.status,
    this.isHidden,
    this.createdAt,
    this.updatedAt,
    this.instructorId,
    this.typeUploadVideoLesson,
    this.section,
    this.ratings,
    this.averagePoint,
    this.instructor,
    this.coursesLikeCategory,
  });

  String id;
  String title;
  String subtitle;
  int price;
  String description;
  dynamic requirement;
  List<String> learnWhat;
  int soldNumber;
  int ratedNumber;
  int videoNumber;
  double totalHours;
  double formalityPoint;
  double contentPoint;
  double presentationPoint;
  String imageUrl;
  dynamic promoVidUrl;
  String status;
  bool isHidden;
  DateTime createdAt;
  DateTime updatedAt;
  String instructorId;
  int typeUploadVideoLesson;
  List<Section> section;
  Ratings ratings;
  String averagePoint;
  Instructor instructor;
  List<CoursesLikeCategory> coursesLikeCategory;

  factory CourseDetail.fromJson(Map<String, dynamic> json) => CourseDetail(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        price: json["price"],
        description: json["description"],
        requirement: json["requirement"],
        learnWhat: List<String>.from(json["learnWhat"].map((x) => x)),
        soldNumber: json["soldNumber"],
        ratedNumber: json["ratedNumber"],
        videoNumber: json["videoNumber"],
        totalHours: json["totalHours"].toDouble(),
        formalityPoint: json["formalityPoint"].toDouble(),
        contentPoint: json["contentPoint"] == null
            ? null
            : json["contentPoint"].toDouble(),
        presentationPoint: json["presentationPoint"].toDouble(),
        imageUrl: json["imageUrl"],
        promoVidUrl: json["promoVidUrl"],
        status: json["status"],
        isHidden: json["isHidden"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        instructorId: json["instructorId"],
        typeUploadVideoLesson: json["typeUploadVideoLesson"],
        section: json["section"] == null
            ? null
            : List<Section>.from(
                json["section"].map((x) => Section.fromJson(x))),
        ratings:
            json["ratings"] == null ? null : Ratings.fromJson(json["ratings"]),
        averagePoint:
            json["averagePoint"] == null ? null : json["averagePoint"],
        instructor: json["instructor"] == null
            ? null
            : Instructor.fromJson(json["instructor"]),
        coursesLikeCategory: json["coursesLikeCategory"] == null
            ? null
            : List<CoursesLikeCategory>.from(json["coursesLikeCategory"]
                .map((x) => CoursesLikeCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "price": price,
        "description": description,
        "requirement": requirement,
        "learnWhat": List<dynamic>.from(learnWhat.map((x) => x)),
        "soldNumber": soldNumber,
        "ratedNumber": ratedNumber,
        "videoNumber": videoNumber,
        "totalHours": totalHours,
        "formalityPoint": formalityPoint,
        "contentPoint": contentPoint == null ? null : contentPoint,
        "presentationPoint": presentationPoint,
        "imageUrl": imageUrl,
        "promoVidUrl": promoVidUrl,
        "status": status,
        "isHidden": isHidden,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "instructorId": instructorId,
        "typeUploadVideoLesson": typeUploadVideoLesson,
        "section": section == null
            ? null
            : List<dynamic>.from(section.map((x) => x.toJson())),
        "ratings": ratings == null ? null : ratings.toJson(),
        "averagePoint": averagePoint == null ? null : averagePoint,
        "instructor": instructor == null ? null : instructor.toJson(),
        "coursesLikeCategory": coursesLikeCategory == null
            ? null
            : List<dynamic>.from(coursesLikeCategory.map((x) => x.toJson())),
      };
}
