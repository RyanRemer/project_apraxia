import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/FormValidator.dart';
import 'package:project_apraxia/model/PasswordRecoveryRequest.dart';
import 'package:project_apraxia/controller/Auth.dart';

class PasswordRecoveryForm extends StatelessWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey();
  final Auth _auth = new Auth.instance();
  final PasswordRecoveryRequest _passwordRecoveryRequest =
      new PasswordRecoveryRequest();

  PasswordRecoveryForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.dialpad),
            title: TextFormField(
              initialValue: _passwordRecoveryRequest.verificationCode,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Verification Code"),
              onSaved: (String verificationCode) {
                _passwordRecoveryRequest.verificationCode = verificationCode;
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.vpn_key),
            title: TextFormField(
              initialValue: _passwordRecoveryRequest.newPassword,
              obscureText: true,
              decoration: InputDecoration(labelText: "New Password"),
              onSaved: (String password) {
                _passwordRecoveryRequest.newPassword = password;
              },
              validator: (String password) =>
                  FormValidator.isValidPassword(password),
            ),
          ),
          RaisedButton(
            child: Text("Change Password"),
            onPressed: () => changePassword(context),
          ),
        ],
      ),
    );
  }

  Future changePassword(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        await _auth.confirmNewPassword(
            _passwordRecoveryRequest.verificationCode,
            _passwordRecoveryRequest.newPassword);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Success"),
                  content: Text("You have successfully changed your password."),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Return to sign in"),
                      onPressed: () => returnToSignIn(context),
                    )
                  ],
                ));
      } on CognitoClientException catch (error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Confirmation Error"),
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

  void returnToSignIn(BuildContext context) {
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
