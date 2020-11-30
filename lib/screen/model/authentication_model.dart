import 'package:world_wisdom/screen/model/user.dart';
import 'package:world_wisdom/screen/model/user_model.dart';

class AuthenticationModel {
  User user;
  String token;

  void setAuthenticationModel(UserModel userModel) {
    this.user = userModel.userInfo;
    this.token = userModel.token;
  }
}
