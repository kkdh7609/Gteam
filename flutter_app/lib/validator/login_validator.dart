class ValidationMixin {
  static String validateEmail(String value) {
    if (value.isEmpty) return "Email can't be empty";

    Pattern pattern = r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$';
    RegExp exp = RegExp(pattern);
    if (!exp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String validatePW(String value) {
    if (value.length < 6) {
      return 'Enter more then 6 letters';
    }
    return null;
  }
}
