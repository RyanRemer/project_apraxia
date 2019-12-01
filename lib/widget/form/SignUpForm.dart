import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter/material.dart';
import 'package:project_apraxia/model/SignUpRequest.dart';
import 'package:project_apraxia/page/RegisterTestPage.dart' as prefix0;
import 'package:project_apraxia/widget/auth.dart';

class SignUpForm extends StatelessWidget {
  GlobalKey<FormState> _formKey = new GlobalKey();
  Auth auth = new Auth();
  SignUpRequest signUpRequest = new SignUpRequest.test();

  SignUpForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.email),
            title: TextFormField(
              initialValue: signUpRequest.email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: "Email"),
              onSaved: (String email) {
                signUpRequest.email = email;
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.vpn_key),
            title: TextFormField(
              initialValue: signUpRequest.password,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
              validator: (String password) {
                if (password.length < 6) {
                  return "Password must be 6 or more characters.";
                }
                return null;
              },
              onSaved: (String password) {
                signUpRequest.password = password;
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: TextFormField(
              initialValue: signUpRequest.name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: "Full Name"),
              validator: (String name) {
                if (name.isEmpty) {
                  return "Name must not be empty.";
                }
                return null;
              },
              onSaved: (String name) {
                signUpRequest.name = name;
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: TextFormField(
              initialValue: signUpRequest.phoneNumber,
              decoration: InputDecoration(labelText: "PhoneNumber"),
              keyboardType: TextInputType.phone,
              validator: (String phoneNumber){
                // TODO: Add phoneNumber validation
              },
              onSaved: (String phoneNumber) {
                signUpRequest.phoneNumber = phoneNumber;
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: TextFormField(
              initialValue: signUpRequest.address,
              maxLines: 2,
              decoration: InputDecoration(labelText: "Address"),
              keyboardType: TextInputType.multiline,
              onSaved: (String address) {
                signUpRequest.address = address;
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
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await auth.signUp(
            signUpRequest.email,
            signUpRequest.password,
            signUpRequest.name,
            signUpRequest.address,
            signUpRequest.phoneNumber);
      } on CognitoClientException catch (error) {
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
