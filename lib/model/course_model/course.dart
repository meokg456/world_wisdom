class Course {
  Course({
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
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.instructorId,
    this.typeUploadVideoLesson,
    this.instructorUserId,
    this.instructorUserName,
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
  double contentPoint;
  double presentationPoint;
  String imageUrl;
  String promoVidUrl;
  String status;
  bool isHidden;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  String instructorId;
  int typeUploadVideoLesson;
  String instructorUserId;
  String instructorUserName;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        price: json["price"],
        description: json["description"],
        requirement: json["requirement"] == null
            ? null
            : List<String>.from(json["requirement"].map((x) => x)),
        learnWhat: json["learnWhat"] == null
            ? null
            : List<String>.from(json["learnWhat"].map((x) => x)),
        soldNumber: json["soldNumber"],
        ratedNumber: json["ratedNumber"],
        videoNumber: json["videoNumber"],
        totalHours: json["totalHours"].toDouble(),
        formalityPoint: json["formalityPoint"].toDouble(),
        contentPoint:
            json["contentPoint"] != null ? json["contentPoint"].toDouble() : 0,
        presentationPoint: json["presentationPoint"].toDouble(),
        imageUrl: json["imageUrl"],
        promoVidUrl: json["promoVidUrl"],
        status: json["status"],
        isHidden: json["isHidden"],
        isDeleted: json["isDeleted"],
        createdAt: DateTime.parse(json["createdAt"] == null
            ? "2020-12-20T09:23:16.988Z"
            : json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        instructorId: json["instructorId"],
        typeUploadVideoLesson: json["typeUploadVideoLesson"],
        instructorUserId: json["instructor.user.id"],
        instructorUserName: json["instructor.user.name"] != null
            ? json["instructor.user.name"]
            : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "price": price,
        "description": description,
        "requirement": List<dynamic>.from(requirement.map((x) => x)),
        "learnWhat": List<dynamic>.from(learnWhat.map((x) => x)),
        "soldNumber": soldNumber,
        "ratedNumber": ratedNumber,
        "videoNumber": videoNumber,
        "totalHours": totalHours,
        "formalityPoint": formalityPoint,
        "contentPoint": contentPoint,
        "presentationPoint": presentationPoint,
        "imageUrl": imageUrl,
        "promoVidUrl": promoVidUrl,
        "status": status,
        "isHidden": isHidden,
        "isDeleted": isDeleted,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "instructorId": instructorId,
        "typeUploadVideoLesson": typeUploadVideoLesson,
        "instructor.user.id": instructorUserId,
        "instructor.user.name": instructorUserName,
      };
}
