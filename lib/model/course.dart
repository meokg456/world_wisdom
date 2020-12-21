class Course {
  Course({
    this.title,
    this.id,
    this.price,
    this.description,
    this.learnWhat,
    this.soldNumber,
    this.ratedNumber,
    this.formalityPoint,
    this.contentPoint,
    this.presentationPoint,
    this.videoNumber,
    this.totalHours,
    this.imageUrl,
    this.updatedAt,
    this.name,
  });

  String title;
  String id;
  int price;
  String description;
  List<String> learnWhat;
  int soldNumber;
  int ratedNumber;
  double formalityPoint;
  double contentPoint;
  double presentationPoint;
  int videoNumber;
  double totalHours;
  String imageUrl;
  DateTime updatedAt;
  String name;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        title: json["title"],
        id: json["id"],
        price: json["price"],
        description: json["description"],
        learnWhat: json["learnWhat"] == null
            ? null
            : List<String>.from(json["learnWhat"].map((x) => x)),
        soldNumber: json["soldNumber"],
        ratedNumber: json["ratedNumber"],
        formalityPoint: json["formalityPoint"].toDouble(),
        contentPoint: json["contentPoint"].toDouble(),
        presentationPoint: json["presentationPoint"].toDouble(),
        videoNumber: json["videoNumber"],
        totalHours: json["totalHours"].toDouble(),
        imageUrl: json["imageUrl"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "id": id,
        "price": price,
        "description": description,
        "learnWhat": learnWhat == null
            ? null
            : List<dynamic>.from(learnWhat.map((x) => x)),
        "soldNumber": soldNumber,
        "ratedNumber": ratedNumber,
        "formalityPoint": formalityPoint,
        "contentPoint": contentPoint,
        "presentationPoint": presentationPoint,
        "videoNumber": videoNumber,
        "totalHours": totalHours,
        "imageUrl": imageUrl,
        "updatedAt": updatedAt.toIso8601String(),
        "name": name,
      };
}
