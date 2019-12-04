import 'dart:async';
import 'package:amazon_cognito_identity_dart/cognito.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class Auth {
  static Auth _instance = new Auth._();
  static final String _userPoolId = "us-west-2_B5Jb6rdZT";
  static final String _clientId = "4b499j87fnc1u5tpvok17r8jq3";
  CognitoUserPool _userPool = new CognitoUserPool(_userPoolId, _clientId);
  CognitoUser _cognitoUser;
  AuthenticationDetails _authDetails;
  CognitoUserSession _session;
  String _jwtToken;

  Auth._();

  factory Auth.instance() {
    return _instance;
  }

  Future<void> signIn(String email, String password) async {
    this._cognitoUser = new CognitoUser(email, this._userPool);
    this._authDetails = new AuthenticationDetails(username: email, password: password);
    this._session = await this._cognitoUser.authenticateUser(this._authDetails);
    this._jwtToken = this._session.getAccessToken().getJwtToken();
  }

  Future<void> signUp(String email, String password, String name, String address, String phone) async {
    var userAttributes = [
      new AttributeArg(name: "email", value: email),
      new AttributeArg(name: "name", value: phone),
      new AttributeArg(name: "address", value: address),
      new AttributeArg(name: "phone_number", value: phone)
    ];
    CognitoUserPoolData data = await this._userPool.signUp(email, password, userAttributes: userAttributes);
    this._cognitoUser = new CognitoUser(email, this._userPool);
    this._authDetails = new AuthenticationDetails(username: email, password: password);
    this._session = await this._cognitoUser.authenticateUser(this._authDetails);
    this._jwtToken = this._session.getAccessToken().getJwtToken();
  }

  Future<void> signOut() async {
    await this._cognitoUser.globalSignOut();
    this._cognitoUser = null;
    this._authDetails = null;
    this._session = null;
    this._jwtToken = null;
  }

  Future<void> resendAuthentication(String email) async {
    this._cognitoUser = new CognitoUser(email, this._userPool);
    await this._cognitoUser.resendConfirmationCode();
  }

  Future<List<CognitoUserAttribute>> getUserAttributes() async {
    return await this._cognitoUser.getUserAttributes();
  }

  Future<void> updateUserAttributes(String email, String address, String phoneNumber, String name) async {
    List<CognitoUserAttribute> attributes = [];
    attributes.add(new CognitoUserAttribute(name: 'phone_number', value: phoneNumber));
    attributes.add(new CognitoUserAttribute(name: 'email', value: email));
    attributes.add(new CognitoUserAttribute(name: 'address', value: address));
    attributes.add(new CognitoUserAttribute(name: 'name', value: name));
    await this._cognitoUser.updateAttributes(attributes);
  }

  Future<String> sendForgotPassword(String email) async {
    this._cognitoUser = new CognitoUser(email, _userPool);
    Map<String, dynamic> data = await this._cognitoUser.forgotPassword();
    return data["CodeDeliveryDetails"]["Destination"];
  }

  Future<bool> confirmNewPassword(String verificationCode, String newPassword) async {
    return await this._cognitoUser.confirmPassword(verificationCode, newPassword);
  }
}
