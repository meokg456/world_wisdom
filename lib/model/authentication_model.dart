import 'package:flutter/material.dart';
import 'package:world_wisdom/model/user_model.dart';
import 'package:world_wisdom/model/user_model.dart';

class AuthenticationModel extends ChangeNotifier {
  User user;
  String token;
  bool isLoggedIn = false;

  void setAuthenticationModel(UserModel userModel) {
    if (userModel == null) {
      this.user = null;
      this.token = null;
      this.isLoggedIn = false;
    }
    this.user = userModel.userInfo;
    this.token = userModel.token;
    this.isLoggedIn = true;
    notifyListeners();
  }
}
