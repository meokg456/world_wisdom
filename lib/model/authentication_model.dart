import 'package:flutter/material.dart';
import 'package:world_wisdom/model/user.dart';
import 'package:world_wisdom/model/user_model.dart';

class AuthenticationModel extends ChangeNotifier {
  User user;
  String token;

  void setAuthenticationModel(UserModel userModel) {
    if (userModel == null) {
      user = null;
      token = null;
    }
    this.user = userModel.userInfo;
    this.token = userModel.token;
    notifyListeners();
  }
}
