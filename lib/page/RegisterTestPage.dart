import 'package:amazon_cognito_identity_dart/cognito.dart';


Future signUp(email, password, {userAttributes}) async {
  final userPool = new CognitoUserPool('us-east-2_wk0EqPR6X', '1i0dmkp6al8ktg4kl4c6qvbdeu');
  try {
    var data = await userPool.signUp(email, password, userAttributes: userAttributes);
    return data;
  } catch (e) {
    print("Error:");
    print(e);
    print("\n");
  }
}

void main() async {
  var email = 'example2@gmail.com';
  var password = 'DummyP@ssword2';
  var userAttributes = [
    new AttributeArg(name: 'email', value: email),
    new AttributeArg(name: 'address', value: 'Bad address'),
    new AttributeArg(name: 'name', value: 'John Smith'),
    new AttributeArg(name: 'phone_number', value: '+11234567890')
  ];


  var data = await signUp(email, password, userAttributes: userAttributes);
  print(data);
}

