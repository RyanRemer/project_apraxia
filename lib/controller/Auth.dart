import 'dart:async';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class Auth {
  static Auth _instance = new Auth._();
  static String _userPoolId = "us-west-2_B5Jb6rdZT";
  static String _clientId = "4b499j87fnc1u5tpvok17r8jq3";
  CognitoUserPool _userPool = new CognitoUserPool(_userPoolId, _clientId);
  CognitoUser _cognitoUser;
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
    await instantiateUser(email, password: password);
    print(this._session.getAccessToken().getJwtToken());
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
      attributes.add(new CognitoUserAttribute(name: 'phone_number', value: phoneNumber));
      attributes.add(new CognitoUserAttribute(name: 'email', value: email));
      attributes.add(new CognitoUserAttribute(name: 'address', value: address));
      attributes.add(new CognitoUserAttribute(name: 'name', value: name));
      await this._cognitoUser.updateAttributes(attributes);
    }
  }

  Future<String> sendForgotPassword(String email) async {
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
      await authenticateUser(email, password);
    }
  }

  Future<void> authenticateUser(String email, String password) async {
    AuthenticationDetails authDetails = new AuthenticationDetails(username: email, password: password);
    this._session = await this._cognitoUser.authenticateUser(authDetails);
  }

  Future<bool> deleteUser(String email, String password) async {
    await instantiateUser(email, password: password);
    return await this._cognitoUser.deleteUser();
  }

  Future<String> getJWT() async {
    if (this._session != null) {
      if (await closeToRefresh()) {
        refreshSession();
      }
      return this._session.getAccessToken().getJwtToken();
    }
//    return null;
    return "eyJraWQiOiJZWTZJak5peWk0ZWVmUjAzd2FKTDVPUmU1SitRbHNZUDJjSjA1Wng4MGZ3PSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiIxNTQyZWRhYy1jMjY2LTQxMmItYmZkOC0zMzlkMTc5OWFmYWYiLCJldmVudF9pZCI6IjI0NmRjYzE4LWE3NTAtNDdkNC05YmFhLWFlYjYwZGMwYmM3NyIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE1Nzk2Mjc5MzUsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC51cy13ZXN0LTIuYW1hem9uYXdzLmNvbVwvdXMtd2VzdC0yX0I1SmI2cmRaVCIsImV4cCI6MTU3OTYzMTUzNSwiaWF0IjoxNTc5NjI3OTM1LCJqdGkiOiJjY2VmYzBhMC1mYTkyLTQ3MzUtOGE0YS1kYzUxM2ZjMTRjZTgiLCJjbGllbnRfaWQiOiI0YjQ5OWo4N2ZuYzF1NXRwdm9rMTdyOGpxMyIsInVzZXJuYW1lIjoiMTU0MmVkYWMtYzI2Ni00MTJiLWJmZDgtMzM5ZDE3OTlhZmFmIn0.UmrS2_4JZXmb3rSuPvwuxIzuwq_3OAyOZBByN0yW2uPRB7T0F-8i9ymRBpRrpdw4Pjw5KmLXhmN9XuHanoO4uIUL_zvIarsQpUsJ_eghlkiAbUnL5hTrU_SbjgIN_dXUIiXOGxNiier122oEC3kFC5DiAnefHzkkCEeB5E9vTTD5b61363A8SKJtzPHtyWyAgb4BatUgsKKTOP89E3oh46f-QI8JqBjSgKWpmEN4EBxcv1yQ9k6Zz1NJeEqheTwOPXkWmdoQmFLp0dyoiXaf5zgPG0hFVaMt2YbEqliXoWw1C8tBR3F9kBZpuDQe4NJ0NDsb_ZnqeHLmi6m66EDSkQ";
  }

  Future<void> refreshSession() async {
    final Map<String, String> authParameters = {
      'REFRESH_TOKEN': this._session.getRefreshToken().getToken()
    };
    final Map<String, dynamic> params = {
      'ClientId': _clientId,
      'AuthFlow': 'REFRESH_TOKEN_AUTH',
      'AuthParameters': authParameters
    };

    var response = await this._userPool.client.request('InitiateAuth', params);
    var authResult = response['AuthenticationResult'];
    this._session.accessToken = CognitoAccessToken(authResult['AccessToken']);
    this._session.idToken = CognitoIdToken(authResult['IdToken']);
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

  void clearAuth() {
    this._cognitoUser = null;
    this._session = null;
  }
}