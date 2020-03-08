import 'package:flutter_test/flutter_test.dart';
import 'package:project_apraxia/controller/FormValidator.dart';


void main() {


  test("FormValidator can detect valid letters", () {
    List<String> validLetters = [
      "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
      "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
    ];
    for (String validLetter in validLetters) {
      expect(FormValidator.isAlphabetic(validLetter), isTrue);
      expect(FormValidator.isAlphabetic(validLetter.toUpperCase()), isTrue);
    }
  });

  test("FormValidator can detect invalid letters", () {
    List<String> invalidLetters = [
      "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ".", ",", "!",
      "@", "#", "\$", "%", "^", "&", "*", "(", ")", "-", "_", "[", "}"
    ];
    for (String invalidLetter in invalidLetters) {
      expect(FormValidator.isAlphabetic(invalidLetter), isFalse);
    }
  });

  test("FormValidator can detect valid numbers", () {
    List<String> validNumbers = [
      "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
    ];
    for (String validNumber in validNumbers) {
      expect(FormValidator.isNumeric(validNumber), isTrue);
    }
  });

  test("FormValidator can detect invalid numbers", () {
    List<String> invalidNumbers = [
      "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
      "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
      ".", ",", "!", "@", "#", "\$", "%", "^", "&", "*", "(", ")", "-",
      "_", "[", "}"
    ];
    for (String invalidNumber in invalidNumbers) {
      expect(FormValidator.isNumeric(invalidNumber), isFalse);
    }
  });

  test("FormValidator can detect valid upper-case letters", () {
    List<String> validLetters = [
      "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
      "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
    ];
    for (String validLetter in validLetters) {
      expect(FormValidator.isUpperCase(validLetter.toUpperCase()), isTrue);
    }
  });

  test("FormValidator can detect invalid upper-case letters", () {
    List<String> invalidLetters = [
      "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
      "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
      "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ".", ",", "!",
      "@", "#", "\$", "%", "^", "&", "*", "(", ")", "-", "_", "[", "}"
    ];
    for (String invalidLetter in invalidLetters) {
      expect(FormValidator.isUpperCase(invalidLetter), isFalse);
    }
  });

  test("FormValidator can detect valid lower-case letters", () {
    List<String> validLetters = [
      "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
      "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
    ];
    for (String validLetter in validLetters) {
      expect(FormValidator.isLowerCase(validLetter), isTrue);
    }
  });

  test("FormValidator can detect invalid lower-case letters", () {
    List<String> invalidLetters = [
      "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
      "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
      "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ".", ",", "!",
      "@", "#", "\$", "%", "^", "&", "*", "(", ")", "-", "_", "[", "}"
    ];
    for (String invalidLetter in invalidLetters) {
      expect(FormValidator.isLowerCase(invalidLetter.toUpperCase()), isFalse);
    }
  });

  test("FormValidator can detect a valid name", () {
    List<String> validNames = [
      "Valid Name",
      "a",
      ".,./adsf'qer1234 a9v/19-02`",
      "!"
    ];
    for (String validName in validNames) {
      expect(FormValidator.isValidName(validName), isNull);
    }
  });

  test("FormValidator can detect an invalid name", () {
    List<String> invalidNames = [
      "",
      null
    ];
    for (String invalidName in invalidNames) {
      expect(FormValidator.isValidName(invalidName), "Name must not be empty.");
    }
  });

  test("FormValidator can detect a valid email address", () {
    List<String> validEmails = [
      "example@exmple.com",
      "a@b.live",
      "test12345@yahoo.com",
      "good3mail@t3st.org"
    ];
    for (String validEmail in validEmails) {
      expect(FormValidator.isValidEmail(validEmail), isNull);
    }
  });

  test("FormValidator can detect an invalid email address", () {
    List<String> invalidEmails = [
      "",
      null,
      "bademail",
      "90154jkv,.`~#*(5)",
      "@.com",
      "@",
      "google.com"
    ];
    for (String invalidEmail in invalidEmails) {
      expect(FormValidator.isValidEmail(invalidEmail), "Invalid email address.");
    }
  });

  test("FormValidator can detect a valid phone number", () {
    List<String> validPhoneNumbers = [
      "1234567890",
      "8018504097",
      "1111111111"
    ];
    for (String validPhoneNumber in validPhoneNumbers) {
      expect(FormValidator.isValidPhoneNumber(validPhoneNumber), isNull);
    }
  });

  test("FormValidator can detect an invalid phone number", () {
    List<String> invalidPhoneNumbers = [
      "",
      null,
      "8123",
      "01293850192835",
      "123.456.7890",
      "(123)456-7890",
      "!@#\$%^()A,"
    ];
    for (String invalidPhoneNumber in invalidPhoneNumbers) {
      expect(FormValidator.isValidPhoneNumber(invalidPhoneNumber), anyOf([
        "Must be 10 digits.",
        "Must not contain any characters besides digits.",
      ]));
    }
  });

  test("FormValidator can detect a valid address", () {
    List<String> validAddresses = [
      "Valid Name",
      "a",
      ".,./adsf'qer1234 a9v/19-02`",
      "!",
      "123 Example Street\nRaleigh, VA 91028"
    ];
    for (String validAddress in validAddresses) {
      expect(FormValidator.isValidAddress(validAddress), isNull);
    }
  });

  test("FormValidator can detect an invalid address", () {
    List<String> invalidAddresses = [
      "",
      null
    ];
    for (String invalidAddress in invalidAddresses) {
      expect(FormValidator.isValidAddress(invalidAddress), "Address must not be empty.");
    }
  });

  test("FormValidator can detect a valid password", () {
    List<String> validPasswords = [
      "Password1",
      "Password123",
      ".,./adsf'qEr1234 a9v/19-02`",
      "PasswordsAr3ReallyLong!",
      "123 Example StreetRaleigh, VA 91028"
    ];
    for (String validPassword in validPasswords) {
      expect(FormValidator.isValidPassword(validPassword), isNull);
    }
  });

  test("FormValidator can detect an invalid password", () {
    List<String> invalidPasswords = [
      "",
      null,
      "Password",
      "password",
      "pass",
      "PASS",
      "Pa1",
      "Pa!",
      "pa!",
      "pa1",
      "passwordsare1",
      "passwordsarereallylong",
      "12345678",
      "1234567"
    ];
    for (String invalidPassword in invalidPasswords) {
      expect(FormValidator.isValidPassword(invalidPassword), anyOf([
        "<8 characters.",
        "No upper-case.",
        "No lower-case.",
        "No numbers.",
        "<8 characters. No upper-case.",
        "<8 characters. No lower-case.",
        "<8 characters. No numbers.",
        "<8 characters. No upper-case. No lower-case.",
        "<8 characters. No upper-case. No numbers.",
        "<8 characters. No lower-case. No numbers.",
        "<8 characters. No upper-case. No lower-case. No numbers.",
        "No upper-case. No numbers.",
        "No upper-case. No lower-case."
      ]));
    }
  });

}