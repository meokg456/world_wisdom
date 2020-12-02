class Validator {
  static String validateEmail(String username) {
    RegExp regExp = new RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    return username.isEmpty
        ? "Username can not be empty"
        : regExp.hasMatch(username)
            ? null
            : "Invalid Email";
  }

  static String validatePassword(String password) {
    return password.isEmpty ? "Password cannot be empty" : null;
  }

  static String validatePhone(String phoneNumber) {
    return phoneNumber.isEmpty
        ? "Phone number cannot be empty"
        : phoneNumber.length > 10
            ? "Phone number cannot be > 10 digits"
            : null;
  }

  static String validateUsername(String username) {
    return username.isEmpty
        ? "Username cannot be empty"
        : username.contains(" ")
            ? "Username cannot have blank characters"
            : null;
  }
}
