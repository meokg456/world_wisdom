import 'package:json_annotation/json_annotation.dart';
import 'package:world_wisdom/screen/model/user.dart';

part 'user_model.g.dart';


@JsonSerializable()
class UserModel {
  String message;
  User userInfo;
  String token;

  UserModel(this.message, this.userInfo, this.token);

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

