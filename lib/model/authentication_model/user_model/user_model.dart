import 'package:world_wisdom/model/authentication_model/user_model/user.dart';

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
        userInfo: User.fromJson(
            json["userInfo"] != null ? json["userInfo"] : json["payload"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "userInfo": userInfo.toJson(),
        "token": token,
      };
}
