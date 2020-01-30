class FormValidator {
  static final int _A = "A".codeUnitAt(0);
  static final int _Z = "Z".codeUnitAt(0);
  static final int _a = "a".codeUnitAt(0);
  static final int _z = "z".codeUnitAt(0);
  static final int _0 = "0".codeUnitAt(0);
  static final int _9 = "9".codeUnitAt(0);

  static bool isAlphabetic(String s) {
    int c = s.codeUnitAt(0);
    return (c >= _A && c <= _Z || c >= _a && c <= _z);
  }

  static bool isNumeric(String s) {
    int c = s.codeUnitAt(0);
    return (c >= _0 && c <= _9);
  }

  static bool isUpperCase(String s) {
    int c = s.codeUnitAt(0);
    return (c >= _A && c <= _Z);
  }

  static bool isLowerCase(String s) {
    int c = s.codeUnitAt(0);
    return (c >= _a && c <= _z);
  }

  static String isValidEmail(String s) {
    if (s == null || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(s)) {
      return "Invalid email address.";
    }
    return null;
  }

  static String isValidName(String s) {
    if (s == null || s.isEmpty) {
      return "Name must not be empty.";
    }
    return null;
  }

  static String isValidPassword(String s) {
    String output = "";
    if (s == null || s.length < 8) {
      output += "<8 characters.";
      if (s == null) {
        return output;
      }
    }
    bool containsUpper = false;
    bool containsLower = false;
    bool containsNumber = false;
    for (int i = 0; i < s.length; i++) {
      if (isAlphabetic(s[i]) && isUpperCase(s[i])) {
        containsUpper = true;
      }
      else if (isAlphabetic(s[i]) && isLowerCase(s[i])) {
        containsLower = true;
      }
      else if (!isAlphabetic(s[i]) && isNumeric(s[i])) {
        containsNumber = true;
      }
    }
    if (!containsUpper) {
      if (output.length > 0) {
        output += " ";
      }
      output += "No upper-case.";
    }
    if (!containsLower) {
      if (output.length > 0) {
        output += " ";
      }
      output += "No lower-case.";
    }
    if (!containsNumber) {
      if (output.length > 0) {
        output += " ";
      }
      output += "No numbers.";
    }
    if (output.length == 0) {
      return null;
    }
    return output;
  }

  static String isValidPhoneNumber(String s) {
    String output = "";
    if (s == null || s.length != 10) {
      output += "Must be 10 digits.";
    }
    else {
      for (int i = 0; i < s.length; i++) {
        if (!isNumeric(s[i])) {
          if (output.length > 0) {
            output += " ";
          }
          output += "Must not contain any characters besides digits.";
          break;
        }
      }
    }
    if (output.length == 0) {
      return null;
    }
    return output;
  }

  static String isValidAddress(String s) {
    if (s == null || s.isEmpty) {
      return "Address must not be empty.";
    }
    return null;
  }

  static String isValidDate(String s) {
    if (s == null || s.isEmpty) {
      return "Date must not be empty.";
    }
    if (s.length != 10) {
      return "Date is in the wrong format.";
    }
    for (int i = 0; i < s.length; i++) {
      if (i == 4 || i == 7) {
        continue;
      }
      if (!isNumeric(s[i])) {
        return "Date is in the wrong format.";
      }
    }
    if (s[4] != "-" || s[7] != "-") {
      return "Date is in the wrong format.";
    }
    return null;
  }

  static String isValidFile(String s) {
    if (s == null || s.isEmpty) {
      return "Must be a valid file name and path.";
    }
    return null;
  }

  static String isValidRelationship(String s) {
    if (s == null || s.isEmpty) {
      return "Must be a valid relationship.";
    }
    return null;
  }
}
