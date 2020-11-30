// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    json['message'] as String,
    json['userInfo'] == null
        ? null
        : User.fromJson(json['userInfo'] as Map<String, dynamic>),
    json['token'] as String,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'message': instance.message,
      'userInfo': instance.userInfo,
      'token': instance.token,
    };
