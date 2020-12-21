class UserModel {
  UserModel({
    this.message,
    this.userInfo,
    this.token,
  });

  String message;
  User userInfo;
  String token;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        message: json["message"],
        userInfo: User.fromJson(json["userInfo"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "userInfo": userInfo.toJson(),
        "token": token,
      };
}

class User {
  User({
    this.id,
    this.email,
    this.avatar,
    this.name,
    this.favoriteCategories,
    this.point,
    this.phone,
    this.type,
    this.isDeleted,
    this.isActivated,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String email;
  String avatar;
  dynamic name;
  List<dynamic> favoriteCategories;
  int point;
  String phone;
  String type;
  bool isDeleted;
  bool isActivated;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        avatar: json["avatar"],
        name: json["name"],
        favoriteCategories:
            List<dynamic>.from(json["favoriteCategories"].map((x) => x)),
        point: json["point"],
        phone: json["phone"],
        type: json["type"],
        isDeleted: json["isDeleted"],
        isActivated: json["isActivated"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "avatar": avatar,
        "name": name,
        "favoriteCategories":
            List<dynamic>.from(favoriteCategories.map((x) => x)),
        "point": point,
        "phone": phone,
        "type": type,
        "isDeleted": isDeleted,
        "isActivated": isActivated,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
