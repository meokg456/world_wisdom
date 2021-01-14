import 'package:flutter/cupertino.dart';
import 'package:world_wisdom/generated/l10n.dart';

class Validator {
  static String validateEmail(BuildContext context, String username) {
    RegExp regExp = new RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    return username.isEmpty
        ? S.of(context).emptyEmailError
        : regExp.hasMatch(username)
            ? null
            : S.of(context).invalidEmail;
  }

  static String validatePassword(BuildContext context, String password) {
    return password.isEmpty ? S.of(context).emptyPasswordError : null;
  }

  static String validateUrl(BuildContext context, String url) {
    return Uri.parse(url).isAbsolute ? null : S.of(context).invalidUrl;
  }

  static String validatePhone(BuildContext context, String phoneNumber) {
    return phoneNumber.isEmpty
        ? S.of(context).emptyPhoneNumberError
        : phoneNumber.length > 10
            ? S.of(context).tooLongPhoneNumber
            : null;
  }

  static String validateUsername(BuildContext context, String username) {
    return username.isEmpty
        ? S.of(context).emptyUsernameError
        : username.contains(" ")
            ? S.of(context).blankCharacterUserNameError
            : null;
  }
}
