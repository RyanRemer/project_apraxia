import 'package:amazon_cognito_identity_dart/cognito.dart';

class UserAttributes {
  String email;
  String name;
  String phoneNumber;
  String address;

  UserAttributes({List<CognitoUserAttribute> attributes}) {
    if (attributes != null) {
      for (CognitoUserAttribute attribute in attributes) {
        if (attribute.getName() == "name") {
          name = attribute.getValue();
        }
        else if (attribute.getName() == "email") {
          email = attribute.getValue();
        }
        else if (attribute.getName() == "address") {
          address = attribute.getValue();
        }
        else if (attribute.getName() == "phone_number") {
          phoneNumber = attribute.getValue();
        }
      }
    }
  }

  UserAttributes.test() {
    email = "drakebwade@gmail.com";
    name = "Drake Wade";
    phoneNumber = "1234567890";
    address = "123 Example St\nCity, State 123456";
  }
}