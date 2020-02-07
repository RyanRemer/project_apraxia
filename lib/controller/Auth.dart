import 'dart:async';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class Auth {
  static Auth _instance = new Auth._();
  static String _userPoolId = "us-west-2_B5Jb6rdZT";
  static String _clientId = "4b499j87fnc1u5tpvok17r8jq3";
  CognitoUserPool _userPool = new CognitoUserPool(_userPoolId, _clientId);
  CognitoUser _user;
  CognitoUserSession _session;
  String _userEmail;

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
    await instantiateUser(email, password: password);
  }

  Future<void> signUp(String email, String password, String name, String address, String phone) async {
    var userAttributes = [
      new AttributeArg(name: "email", value: email),
      new AttributeArg(name: "name", value: name),
      new AttributeArg(name: "address", value: address),
      new AttributeArg(name: "phone_number", value: phone)
    ];
    await this._userPool.signUp(email, password, userAttributes: userAttributes);
    await instantiateUser(email, password: password);
  }

  Future<void> signOut() async {
    if (this._user != null) {
      await this._user.globalSignOut();
    }
    clearAuth();
  }

  Future<void> resendAuthentication(String email) async {
    if (this._user != null) {
      await this._user.resendConfirmationCode();
    }
  }

  Future<List<CognitoUserAttribute>> getUserAttributes() async {
    if (this._user != null) {
      return await this._user.getUserAttributes();
    }
    return new List<CognitoUserAttribute>();
  }

  Future<void> updateUserAttributes(String email, String address, String phoneNumber, String name) async {
    if (this._user != null) {
      List<CognitoUserAttribute> attributes = [];
      attributes.add(new CognitoUserAttribute(name: 'phone_number', value: phoneNumber));
      attributes.add(new CognitoUserAttribute(name: 'email', value: email));
      attributes.add(new CognitoUserAttribute(name: 'address', value: address));
      attributes.add(new CognitoUserAttribute(name: 'name', value: name));
      await this._user.updateAttributes(attributes);
    }
  }

  Future<String> sendForgotPassword(String email) async {
    if (this._user != null) {
      Map<String, dynamic> data = await this._user.forgotPassword();
      return data["CodeDeliveryDetails"]["Destination"];
    }
    return null;
  }

  Future<bool> confirmNewPassword(String verificationCode, String newPassword) async {
    if (this._user == null) {
      return false;
    }
    return await this._user.confirmPassword(verificationCode, newPassword);
  }

  Future<void> instantiateUser(String email, {String password}) async {
    this._user = new CognitoUser(email, _userPool);
    this._userEmail = email;
    if (password != null) {
      await authenticateUser(email, password);
    }
  }

  Future<void> authenticateUser(String email, String password) async {
    if (this._user != null) {
      AuthenticationDetails authDetails = new AuthenticationDetails(username: email, password: password);
      this._session = await this._user.authenticateUser(authDetails);
    }
  }

  Future<bool> deleteUser(String email, String password) async {
    if (this._user != null) {
      return await this._user.deleteUser();
    }
    return false;
  }

  Future<String> getJWT() async {
    if (this._session != null) {
      if (await closeToRefresh()) {
        refreshSession();
      }
      return this._session.getAccessToken().getJwtToken();
    }
    return null;
  }

  Future<void> refreshSession() async {
    this._session = await this._user.refreshSession(this._session.getRefreshToken());
  }

  Future<bool> closeToRefresh() async {
    if (this._session != null) {
      int currTime = ((new DateTime.now()).millisecondsSinceEpoch / 1000).floor();
      if (this._session.getAccessToken().getExpiration() - currTime < 300 || !this._session.isValid()) {
        return true;
      }
      return false;
    }
    return true;
  }

  String get userEmail => _userEmail;

  void clearAuth() {
    this._user = null;
    this._session = null;
    this._userEmail = null;
  }
}