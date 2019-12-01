class SignUpRequest {
  String email;
  String password;
  String name;
  String phoneNumber;
  String address;

  SignUpRequest();

  SignUpRequest.test(){
    email = "example@example.com";
    password = "Password";
    name = "John Doe";
    phoneNumber = "444-444-4444";
    address = "123 Example St\nCity, State 123456";
  }
}