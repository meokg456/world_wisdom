import 'package:flutter/cupertino.dart';
import 'package:world_wisdom/screen/key/key.dart';

class Handler {
  static void unauthorizedHandler(BuildContext context) {
    Keys.appNavigationKey.currentState.pushNamed("/authentication/login");
  }
}
