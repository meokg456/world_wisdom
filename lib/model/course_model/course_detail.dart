import 'package:world_wisdom/model/course_model/course.dart';
import 'package:world_wisdom/model/instructor_model/instructor.dart';
import 'package:world_wisdom/model/rate_model/rate_model.dart';
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
    this.averagePoint,
    this.imageUrl,
    this.promoVidUrl,
    this.status,
    this.isHidden,
    this.createdAt,
    this.updatedAt,
    this.instructorId,
    this.typeUploadVideoLesson,
    this.sections,
    this.ratings,
    this.instructor,
    this.coursesLikeCategory,
  });

  String id;
  String title;
  String subtitle;
  int price;
  String description;
  List<String> requirement;
  List<String> learnWhat;
  int soldNumber;
  int ratedNumber;
  int videoNumber;
  double totalHours;
  double formalityPoint;
  String averagePoint;
  double contentPoint;
  double presentationPoint;
  String imageUrl;
  String promoVidUrl;
  String status;
  bool isHidden;
  DateTime createdAt;
  DateTime updatedAt;
  String instructorId;
  int typeUploadVideoLesson;
  List<Section> sections;
  RateModel ratings;
  Instructor instructor;
  List<Course> coursesLikeCategory;

  factory CourseDetail.fromJson(Map<String, dynamic> json) => CourseDetail(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        price: json["price"],
        description: json["description"],
        requirement: json["requirement"] == null
            ? []
            : List<String>.from(json["requirement"].map((x) => x)),
        learnWhat: List<String>.from(json["learnWhat"].map((x) => x)),
        soldNumber: json["soldNumber"],
        ratedNumber: json["ratedNumber"],
        videoNumber: json["videoNumber"],
        totalHours: json["totalHours"].toDouble(),
        formalityPoint: json["formalityPoint"] != null
            ? json["formalityPoint"].toDouble()
            : json["courseFormalityPoint"] != null
                ? json["courseFormalityPoint"].toDouble()
                : 0,
        contentPoint: json["contentPoint"] != null
            ? json["contentPoint"].toDouble()
            : json["courseContentPoint"] != null
                ? json["courseContentPoint"].toDouble()
                : 0,
        presentationPoint: json["presentationPoint"] != null
            ? json["presentationPoint"].toDouble()
            : json["coursePresentationPoint"] != null
                ? json["coursePresentationPoint"].toDouble()
                : 0,
        averagePoint: json["averagePoint"] != null ? json["averagePoint"] : "",
        imageUrl: json["imageUrl"],
        promoVidUrl: json["promoVidUrl"],
        status: json["status"],
        isHidden: json["isHidden"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        instructorId: json["instructorId"],
        typeUploadVideoLesson: json["typeUploadVideoLesson"],
        sections: json["section"] == null
            ? null
            : List<Section>.from(
                json["section"].map((x) => Section.fromJson(x))),
        ratings: json["ratings"] == null
            ? null
            : RateModel.fromJson(json["ratings"]),
        instructor: json["instructor"] == null
            ? null
            : Instructor.fromJson(json["instructor"]),
        coursesLikeCategory: json["coursesLikeCategory"] == null
            ? null
            : List<Course>.from(
                json["coursesLikeCategory"].map((x) => Course.fromJson(x))),
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
        "section": sections == null
            ? null
            : List<dynamic>.from(sections.map((x) => x.toJson())),
        "ratings": ratings == null ? null : ratings.toJson(),
        "averagePoint": averagePoint == null ? null : averagePoint,
        "instructor": instructor == null ? null : instructor.toJson(),
        "coursesLikeCategory": coursesLikeCategory == null
            ? null
            : List<dynamic>.from(coursesLikeCategory.map((x) => x.toJson())),
      };
}
