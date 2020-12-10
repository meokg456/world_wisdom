import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  String id;
  String email;
  String avatar;
  String name;
  int point;
  String phone;
  String type;
  bool isDeleted;
  bool isActivated;
  DateTime createAt;
  DateTime updateAt;

  User(
      this.id,
      this.email,
      this.avatar,
      this.name,
      this.point,
      this.phone,
      this.type,
      this.isDeleted,
      this.isActivated,
      this.createAt,
      this.updateAt);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}