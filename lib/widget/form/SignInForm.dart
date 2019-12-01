import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter/material.dart';
import 'package:project_apraxia/model/SignInRequest.dart';
import 'package:project_apraxia/page/RecordPage.dart';
import 'package:project_apraxia/widget/auth.dart';

class SignInForm extends StatelessWidget {
  GlobalKey<FormState> _formKey = new GlobalKey();
  Auth auth = new Auth();
  SignInRequest signInRequest = new SignInRequest.test();

  SignInForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.email),
            title: TextFormField(
              initialValue: signInRequest.email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: "Email"),
              onSaved: (String email) {
                signInRequest.email = email;
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.vpn_key),
            title: TextFormField(
              initialValue: signInRequest.password,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
              onSaved: (String password) {
                signInRequest.password = password;
              },
            ),
          ),
          RaisedButton(
            child: Text("Sign In"),
            onPressed: () => signIn(context),
          )
        ],
      ),
    );
  }

  Future signIn(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        await auth.signIn(signInRequest.email, signInRequest.password);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RecordPage()));
      } on CognitoClientException catch (error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Sign In Error"),
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
