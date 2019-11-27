import 'dart:async';
import 'package:flutter/services.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class Auth {
  String userPoolId = 'us-west-2_B5Jb6rdZT';
  String clientId = '4b499j87fnc1u5tpvok17r8jq3';
  String email;
  CognitoUserPool userPool;
  CognitoUser cognitoUser;
  AuthenticationDetails authDetails;
  CognitoUserSession session;
  String jwtToken;

  Future signIn(String email, String password) async {
    this.email = email;
    if (this.userPool == null) {
      this.userPool = new CognitoUserPool(userPoolId, clientId);
    }
    this.cognitoUser = new CognitoUser(email, userPool);
    this.authDetails = new AuthenticationDetails(username: email, password: password);
//    try {
    this.session = await cognitoUser.authenticateUser(authDetails);
//    } on CognitoUserNewPasswordRequiredException catch (e) {
//      // handle New Password challenge
//    } on CognitoUserMfaRequiredException catch (e) {
//      // handle SMS_MFA challenge
//    } on CognitoUserSelectMfaTypeException catch (e) {
//      // handle SELECT_MFA_TYPE challenge
//    } on CognitoUserMfaSetupException catch (e) {
//      // handle MFA_SETUP challenge
//    } on CognitoUserTotpRequiredException catch (e) {
//      // handle SOFTWARE_TOKEN_MFA challenge
//    } on CognitoUserCustomChallengeException catch (e) {
//      // handle CUSTOM_CHALLENGE challenge
//    } on CognitoUserConfirmationNecessaryException catch (e) {
//      // handle User Confirmation Necessary
//    } catch (e) {
//      print(e);
//    }
    this.jwtToken = session.getAccessToken().getJwtToken();
    return this.jwtToken;
  }

  Future<String> signUp(String email, String password, String name, String address, String phone) async {
    var userAttributes = [
      new AttributeArg(name: 'email', value: email),
      new AttributeArg(name: 'name', value: phone),
      new AttributeArg(name: 'address', value: address),
      new AttributeArg(name: 'phone_number', value: phone)
    ];
    if (this.userPool == null) {
      this.userPool = new CognitoUserPool(userPoolId, clientId);
    }
    var data = await userPool.signUp(email, password, userAttributes: userAttributes);
    this.cognitoUser = new CognitoUser(email, userPool);
    this.authDetails = new AuthenticationDetails(username: email, password: password);
    this.session = await cognitoUser.authenticateUser(authDetails);
    this.jwtToken = this.session.getAccessToken().getJwtToken();
    return this.jwtToken;
  }

  Future<void> signOut() async {
//    return FirebaseAuth.instance.signOut();
    await cognitoUser.globalSignOut();
  }

//  Future<FirebaseUser> getCurrentFirebaseUser() async {
//    FirebaseUser user = await FirebaseAuth.instance.currentUser();
//    return user;
//  }

//  void addUser(User user) async {
//    checkUserExist(user.userID).then((value) {
//      if (!value) {
//        print("user ${user.firstName} ${user.email} added");
//        Firestore.instance
//            .document("users/${user.userID}")
//            .setData(user.toJson());
//      } else {
//        print("user ${user.firstName} ${user.email} exists");
//      }
//    });
//  }

//  Future<bool> checkUserExist(String userID) async {
//    bool exists = false;
//    try {
//      await Firestore.instance.document("users/$userID").get().then((doc) {
//        if (doc.exists)
//          exists = true;
//        else
//          exists = false;
//      });
//      return exists;
//    } catch (e) {
//      return false;
//    }
//  }

//  Stream<User> getUser(String userID) {
//    return Firestore.instance
//        .collection("users")
//        .where("userID", isEqualTo: userID)
//        .snapshots()
//        .map((QuerySnapshot snapshot) {
//      return snapshot.documents.map((doc) {
//        return User.fromDocument(doc);
//      }).first;
//    });
//  }

  static String getExceptionText(Exception e) {
    return e.toString();
//    if (e is PlatformException) {
//      switch (e.message) {
//        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
//          return 'User with this e-mail not found.';
//          break;
//        case 'The password is invalid or the user does not have a password.':
//          return 'Invalid password.';
//          break;
//        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
//          return 'No internet connection.';
//          break;
//        case 'The email address is already in use by another account.':
//          return 'Email address is already taken.';
//          break;
//        default:
//          return 'Unknown error occured.';
//      }
//    } else {
//      return 'Unknown error occured.';
//    }
  }
}
