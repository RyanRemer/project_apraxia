import 'dart:async';
import 'package:amazon_cognito_identity_dart/cognito.dart';

class Auth {
  static Auth _instance = new Auth._();
  static String _userPoolId = "us-west-2_B5Jb6rdZT";
  static String _clientId = "4b499j87fnc1u5tpvok17r8jq3";
  CognitoUserPool _userPool = new CognitoUserPool(_userPoolId, _clientId);
  CognitoUser _cognitoUser;
  AuthenticationDetails _authDetails;
  CognitoUserSession _session;

  Auth._();

  factory Auth.instance({String userPoolId, String clientId}) {
    if (userPoolId != null && clientId != null) {
      _userPoolId = userPoolId;
      _clientId = clientId;
      _instance._userPool = new CognitoUserPool(userPoolId, clientId);
    }
    return _instance;
  }

  Future<void> signIn(String email, String password) async {
    instantiateUser(email, password: password);
  }

  Future<void> signUp(String email, String password, String name, String address, String phone) async {
    var userAttributes = [
      new AttributeArg(name: "email", value: email),
      new AttributeArg(name: "name", value: phone),
      new AttributeArg(name: "address", value: address),
      new AttributeArg(name: "phone_number", value: phone)
    ];
    await this._userPool.signUp(email, password, userAttributes: userAttributes);
    await instantiateUser(email, password: password);
  }

  Future<void> signOut() async {
    if (this._cognitoUser != null) {
      await this._cognitoUser.globalSignOut();
    }
    clearAuth();
  }

  Future<void> resendAuthentication(String email) async {
    await instantiateUser(email);
    await this._cognitoUser.resendConfirmationCode();
  }

  Future<List<CognitoUserAttribute>> getUserAttributes() async {
    if (this._cognitoUser != null) {
      return await this._cognitoUser.getUserAttributes();
    }
    return new List<CognitoUserAttribute>();
  }

  Future<void> updateUserAttributes(String email, String address, String phoneNumber, String name) async {
    if (this._cognitoUser != null) {
      List<CognitoUserAttribute> attributes = [];
      attributes.add(
          new CognitoUserAttribute(name: 'phone_number', value: phoneNumber));
      attributes.add(new CognitoUserAttribute(name: 'email', value: email));
      attributes.add(new CognitoUserAttribute(name: 'address', value: address));
      attributes.add(new CognitoUserAttribute(name: 'name', value: name));
      await this._cognitoUser.updateAttributes(attributes);
    }
  }

  Future<String> sendForgotPassword(String email) async {
    await instantiateUser(email);
    Map<String, dynamic> data = await this._cognitoUser.forgotPassword();
    return data["CodeDeliveryDetails"]["Destination"];
  }

  Future<bool> confirmNewPassword(String verificationCode, String newPassword) async {
    if (this._cognitoUser == null) {
      return false;
    }
    return await this._cognitoUser.confirmPassword(verificationCode, newPassword);
  }

  Future<void> instantiateUser(String email, {String password}) async {
    this._cognitoUser = new CognitoUser(email, _userPool);
    if (password != null) {
      authenticateUser(email, password);
    }
  }

  Future<void> authenticateUser(String email, String password) async {
    this._authDetails = new AuthenticationDetails(username: email, password: password);
    this._session = await this._cognitoUser.authenticateUser(this._authDetails);
  }

  Future<bool> deleteUser(String email, String password) async {
    instantiateUser(email, password: password);
    return await this._cognitoUser.deleteUser();
  }

  String getSessionAccessToken() {
    if (this._session != null) {
      return this._session.getAccessToken().getJwtToken();
    }
    return null;
  }

  void clearAuth() {
    this._cognitoUser = null;
    this._authDetails = null;
    this._session = null;
  }

}