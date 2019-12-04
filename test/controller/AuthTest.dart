import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_apraxia/controller/Auth.dart';


class DummyUser {
  static final String email = "projectapraxia@gmail.com";
  static final String name = "Tyson Harmon";
  static final String address = "123 Main St.\nRichmond, VA 98021";
  static final String phoneNumber = "+11234567890";
  static final String password = "Password1";
}

Future<bool> performSignUp(Auth auth) async {
  try {
    await auth.signUp(DummyUser.email, DummyUser.password, DummyUser.name,
        DummyUser.address, DummyUser.phoneNumber);
    return true;
  } on CognitoClientException catch (e) {
    if (e.name == "UserNotConfirmedException") {
      return true;
    }
    return false;
  } on Exception catch (e) {
    print(e);
    return false;
  }
}

Future<void> performConfirmUser(Auth auth) async {
  String confirmationCode = "123456";
  try {
    await auth.confirmUser(DummyUser.email, confirmationCode);
  } on CognitoClientException catch (e) {
    print(e);
  }
}

Future<bool> performDeleteUser(Auth auth) async {
  try {
    auth.deleteUser(DummyUser.email);
    return true;
  } on CognitoClientException {
    return true;
  } on Exception catch (e) {
    if (e.toString() == "User is not authenticated") {
      return true;
    }
    return false;
  }
}


void main() {
  Auth auth = Auth.instance(userPoolId: "us-west-2_3ECfcartt", clientId: "5tpn2ujes5chjlrlo92ge9po1i");

//  setUp(() {
//    expect(performDeleteUser(auth), isException);
//  });

  test("Auth can sign up a test user", () async {
    expect(await performSignUp(auth), isTrue);
  });


}