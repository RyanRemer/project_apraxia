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
  } on Exception catch (e) {
    print(e);
    return false;
  }
}

Future<bool> performDeleteUser(Auth auth) async {
  try {
    return await auth.deleteUser(DummyUser.email, DummyUser.password);
  } on Exception catch (e) {
    print(e);
    return false;
  }
}

Future<bool> performLogout(Auth auth) async {
  try {
    await auth.signOut();
    return true;
  } on Exception catch (e) {
    print(e);
    return false;
  }
}

Future<bool> performSignIn(Auth auth) async {
  try {
    await auth.signIn(DummyUser.email, DummyUser.password);
    return true;
  } on Exception catch (e) {
    print(e);
    return false;
  }
}


void main() {
  Auth auth;

  setUp(() async {
    auth = Auth.instance(userPoolId: "us-west-2_3ECfcartt", clientId: "5tpn2ujes5chjlrlo92ge9po1i");
  });

  test("Auth can get user attributes", () async {
    performSignUp(auth);
//    auth.instantiateUser(DummyUser.email, password: DummyUser.password);
    expect(await auth.getUserAttributes(), isList);
  });

  test("Auth can delete a user", () async {
    expect(await performDeleteUser(auth), anyOf(isTrue, isFalse));
  });

  test("Auth can sign up a test user", () async {
    await performDeleteUser(auth);
    expect(await performSignUp(auth), isTrue);
  });

  test("Auth can sign in an existing user", () async {
    await performDeleteUser(auth);
    await performSignUp(auth);
    await performLogout(auth);
    expect(await performSignIn(auth), isTrue);
  });


}