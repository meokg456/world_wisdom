import 'package:world_wisdom/model/authentication_model/user_model/user_type.dart';

class User {
  User({
    this.id,
    this.email,
    this.password,
    this.avatar,
    this.name,
    this.favoriteCategories,
    this.point,
    this.phone,
    this.type,
    this.facebookId,
    this.googleId,
    this.isDeleted,
    this.isActivated,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String email;
  String password;
  String avatar;
  String name;
  List<String> favoriteCategories;
  int point;
  String phone;
  Type type;
  dynamic facebookId;
  String googleId;
  bool isDeleted;
  bool isActivated;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        avatar: json["avatar"],
        name: json["name"],
        favoriteCategories:
            List<String>.from(json["favoriteCategories"].map((x) => x)),
        point: json["point"],
        phone: json["phone"],
        type: typeValues.map[json["type"]],
        facebookId: json["facebookId"],
        googleId: json["googleId"] == null ? null : json["googleId"],
        isDeleted: json["isDeleted"],
        isActivated: json["isActivated"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "avatar": avatar,
        "name": name,
        "favoriteCategories":
            List<dynamic>.from(favoriteCategories.map((x) => x)),
        "point": point,
        "phone": phone,
        "type": typeValues.reverse[type],
        "facebookId": facebookId,
        "googleId": googleId == null ? null : googleId,
        "isDeleted": isDeleted,
        "isActivated": isActivated,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
