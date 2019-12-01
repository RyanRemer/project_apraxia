class SignInRequest {
  String email;
  String password;

  SignInRequest();

  SignInRequest.test(){
    email = "example@example.com";
    password = "Password";
  }
}