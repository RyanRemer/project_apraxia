import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:project_apraxia/model/SignUpRequest.dart';
import 'package:project_apraxia/controller/FormValidator.dart';
import 'package:project_apraxia/controller/Auth.dart';
import 'package:project_apraxia/page/SignInPage.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpForm extends StatefulWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey();

  SignUpForm({Key key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final SignUpRequest signUpRequest = new SignUpRequest.test();
  final Auth _auth = new Auth.instance();
  final SignUpRequest _signUpRequest = new SignUpRequest.test();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: SignUpForm._formKey,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.email),
            title: TextFormField(
              initialValue: _signUpRequest.attributes.email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "email@example.com",
              ),
              onSaved: (String email) {
                _signUpRequest.attributes.email = email;
              },
              validator: (String email) {
                return FormValidator.isValidEmail(email);
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.vpn_key),
            title: TextFormField(
              initialValue: _signUpRequest.password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Password1",
              ),
              validator: (String password) {
                return FormValidator.isValidPassword(password);
              },
              onSaved: (String password) {
                _signUpRequest.password = password;
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: TextFormField(
              initialValue: _signUpRequest.attributes.name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: "Full Name",
                hintText: "First Last",
              ),
              validator: (String name) {
                return FormValidator.isValidName(name);
              },
              onSaved: (String name) {
                _signUpRequest.attributes.name = name;
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: InternationalPhoneNumberInput.withCustomDecoration(
              onInputChanged: (PhoneNumber number) {
                _signUpRequest.attributes.phoneNumber = number.phoneNumber;
              },
              isEnabled: true,
              autoValidate: true,
              formatInput: true,
              countries: ['US', 'CA'],
              initialCountry2LetterCode: 'US',
              textFieldController: TextEditingController(
                  text: _signUpRequest.attributes.phoneNumber.substring(2)),
              inputDecoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: '123-456-7890',
                labelText: 'Phone Number',
              ),
              errorMessage: 'Invalid phone number',
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: TextFormField(
              initialValue: _signUpRequest.attributes.address,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Address",
                hintText: "123 Main St.\nSpringfield, VA 22162",
              ),
              keyboardType: TextInputType.multiline,
              onSaved: (String address) {
                _signUpRequest.attributes.address = address;
              },
              validator: (String address) {
                return FormValidator.isValidAddress(address);
              },
            ),
          ),
          ButtonBar(
            children: <Widget>[
              RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Sign Up"),
                ),
                onPressed: () => this.signUp(context),
              )
            ],
          )
        ],
      ),
    );
  }

  Future signUp(BuildContext context) async {
    if (SignUpForm._formKey.currentState.validate()) {
      SignUpForm._formKey.currentState.save();
      try {
        await _auth.signUp(
          _signUpRequest.attributes.email,
          _signUpRequest.password,
          _signUpRequest.attributes.name,
          _signUpRequest.attributes.address,
          _signUpRequest.attributes.phoneNumber,
        );
      } on CognitoClientException catch (error) {
        if (error.name == "UserNotConfirmedException") {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Account Unconfirmed"),
              content: Text(
                  "Your account is created but your email is not yet verified. You will receive an email shortly with a verification link in it. Click on the link to verify your email address and then sign in."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Okay"),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          );
          goToSignIn(context);
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
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
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => SignInPage()));
  }
}
