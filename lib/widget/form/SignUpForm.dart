import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:project_apraxia/model/SignUpRequest.dart';
import 'package:project_apraxia/controller/FormValidator.dart';
import 'package:project_apraxia/controller/Auth.dart';
import 'package:project_apraxia/page/SignInPage.dart';
import 'package:international_phone_input/international_phone_input.dart';

class SignUpForm extends StatefulWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey();

  SignUpForm({Key key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final Auth auth = new Auth.instance();
  final SignUpRequest signUpRequest = new SignUpRequest.test();
  bool validPhoneNumber = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: SignUpForm._formKey,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.email),
            title: TextFormField(
              initialValue: signUpRequest.attributes.email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "email@example.com"
              ),
              onSaved: (String email) {
                signUpRequest.attributes.email = email;
              },
              validator: (String email) {
                return FormValidator.isValidEmail(email);
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.vpn_key),
            title: TextFormField(
              initialValue: signUpRequest.password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Password1"
              ),
              validator: (String password) {
                return FormValidator.isValidPassword(password);
              },
              onSaved: (String password) {
                signUpRequest.password = password;
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: TextFormField(
              initialValue: signUpRequest.attributes.name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: "Full Name",
                hintText: "First Last"
              ),
              validator: (String name) {
                return FormValidator.isValidName(name);
              },
              onSaved: (String name) {
                signUpRequest.attributes.name = name;
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: InternationalPhoneInput(
              onPhoneNumberChange: (String number, String internationalizedPhoneNumber, String isoCode) {
                if (internationalizedPhoneNumber != "") {
                  signUpRequest.attributes.phoneNumber = internationalizedPhoneNumber;
                  validPhoneNumber = true;
                }
                else {
                  validPhoneNumber = false;
                }
              },
              initialPhoneNumber: signUpRequest.attributes.phoneNumber,
              initialSelection: "US",
              hintText: "000-000-0000",
              errorText: "Invalid phone number",
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: TextFormField(
              initialValue: signUpRequest.attributes.address,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Address",
                hintText: "123 Main St.\nSpringfield, VA 22162"
              ),
              keyboardType: TextInputType.multiline,
              onSaved: (String address) {
                signUpRequest.attributes.address = address;
              },
              validator: (String address) {
                return FormValidator.isValidAddress(address);
              },
            ),
          ),
          RaisedButton(
            child: Text("Sign Up"),
            onPressed: () => this.signUp(context),
          )
        ],
      ),
    );
  }

  Future signUp(BuildContext context) async {
    if (SignUpForm._formKey.currentState.validate() && validPhoneNumber) {
      SignUpForm._formKey.currentState.save();
      try {
        await auth.signUp(
            signUpRequest.attributes.email,
            signUpRequest.password,
            signUpRequest.attributes.name,
            signUpRequest.attributes.address,
            signUpRequest.attributes.phoneNumber);
      } on CognitoClientException catch (error) {
        if (error.name == "UserNotConfirmedException") {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Account Unconfirmed"),
              content: Text("Your account is created but your email is not yet verified. You will receive an email shortly with a verification link in it. Click on the link to verify your email address and then sign in."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Okay"),
                  onPressed: () => goToSignIn(context),
                )
              ],
            ),
          );
        }
        else {
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text("Sign Up Error"),
                  content: Text(error.message),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Okay"),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
          );
        }
      }
    }
  }

  void goToSignIn(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignInPage()));
  }
}
