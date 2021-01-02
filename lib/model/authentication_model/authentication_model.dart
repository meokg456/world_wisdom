import 'package:flutter/material.dart';
import 'package:world_wisdom/model/authentication_model/user_model/user.dart';
import 'package:world_wisdom/model/authentication_model/user_model/user_model.dart';

class AuthenticationModel extends ChangeNotifier {
  User user;
  String token;
  bool isLoggedIn = false;

  void setAuthenticationModel(UserModel userModel) {
    if (userModel == null) {
      this.user = null;
      this.token = null;
      this.isLoggedIn = false;
      notifyListeners();
      return;
    }
    this.user = userModel.userInfo;
    this.token = userModel.token;
    this.isLoggedIn = true;
    notifyListeners();
  }
}
