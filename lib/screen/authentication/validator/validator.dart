class Validator {
  static String validateEmail(String username) {
    RegExp regExp = new RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    return username.isEmpty ? "Username can not be empty" : regExp.hasMatch(username) ? null : "Invalid Email";
  }
  static String validatePassword(String password) {
    return password.isEmpty ? "Password can not be empty" : null;
  }
}