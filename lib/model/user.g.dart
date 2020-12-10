// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'] as String,
    json['email'] as String,
    json['avatar'] as String,
    json['name'] as String,
    json['point'] as int,
    json['phone'] as String,
    json['type'] as String,
    json['isDeleted'] as bool,
    json['isActivated'] as bool,
    json['createAt'] == null
        ? null
        : DateTime.parse(json['createAt'] as String),
    json['updateAt'] == null
        ? null
        : DateTime.parse(json['updateAt'] as String),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'avatar': instance.avatar,
      'name': instance.name,
      'point': instance.point,
      'phone': instance.phone,
      'type': instance.type,
      'isDeleted': instance.isDeleted,
      'isActivated': instance.isActivated,
      'createAt': instance.createAt?.toIso8601String(),
      'updateAt': instance.updateAt?.toIso8601String(),
    };
