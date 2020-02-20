class FormValidator {
  static final int _capAValue = "A".codeUnitAt(0);
  static final int _capZValue = "Z".codeUnitAt(0);
  static final int _lowAValue = "a".codeUnitAt(0);
  static final int _lowZValue = "z".codeUnitAt(0);
  static final int _zeroValue = "0".codeUnitAt(0);
  static final int _nineValue = "9".codeUnitAt(0);

  static bool isAlphabetic(String s) {
    int c = s.codeUnitAt(0);
    return (c >= _capAValue && c <= _capZValue || c >= _lowAValue && c <= _lowZValue);
  }

  static bool isNumeric(String s) {
    int c = s.codeUnitAt(0);
    return (c >= _zeroValue && c <= _nineValue);
  }

  static bool isUpperCase(String s) {
    int c = s.codeUnitAt(0);
    return (c >= _capAValue && c <= _capZValue);
  }

  static bool isLowerCase(String s) {
    int c = s.codeUnitAt(0);
    return (c >= _lowAValue && c <= _lowZValue);
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

  static String isValidDate(DateTime dateTime) {
    if (dateTime == null) {
      return "Date must not be empty";
    }
    return null;
  }

  static String isValidAge(String s) {
    if (s == null || s.trim() == "") {
      return "Age must not be empty";
    }
    try {
      int age = int.parse(s);
      if (age < 0) {
        return "Age must not be negative";
      }
      else if (age > 150) {
        return "Age must be less than 150.";
      }
      return null;
    } on FormatException {
      return "Must be a valid age.";
    }
  }
}
