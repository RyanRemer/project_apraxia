import 'package:project_apraxia/model/UserAttributes.dart';

class SignUpRequest {
  String password;
  UserAttributes attributes = new UserAttributes();

  SignUpRequest();

  SignUpRequest.test(){
    this.password = "Password1";
    this.attributes = new UserAttributes.test();
  }
}