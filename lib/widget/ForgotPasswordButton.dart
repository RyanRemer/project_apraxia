import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/FormValidator.dart';
import 'package:project_apraxia/page/PasswordRecoveryPage.dart';
import 'package:project_apraxia/controller/Auth.dart';

class ForgotPasswordButton extends StatefulWidget {
  final String buttonType;
  final String buttonText;

  ForgotPasswordButton({Key key, this.buttonType = 'flat', this.buttonText = 'Forgot Password?'}) : super(key: key);

  @override
  _ForgotPasswordButtonState createState() => _ForgotPasswordButtonState();
}

class _ForgotPasswordButtonState extends State<ForgotPasswordButton> {
  final Auth _auth = new Auth.instance();
  static GlobalKey<FormState> _formKey = new GlobalKey();
  String _email;

  @override
  Widget build(BuildContext context) {
    if (widget.buttonType.toLowerCase() == 'flat') {
      return FlatButton(
        child: Text(widget.buttonText),
        onPressed: () async => await promptForEmail(context),
      );
    }
    else if (widget.buttonType.toLowerCase() == 'raised') {
      return RaisedButton(
        child: Text(widget.buttonText),
        onPressed: () async => await promptForEmail(context),
      );
    }
    else {
      throw new Exception('Invalid button type');
    }
  }

  Future<void> promptForEmail(BuildContext context) async {
    showDialog(
      context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter email"),
            content:Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget> [
                    Text("Enter the email for your account. If there is an account with that email, you will receive an email with a code to enter and reset your password."),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Account Email",
                          hintText: "email@example.com"
                      ),
                      onChanged: (String value) {
                        _email = value;
                      },
                      validator: (String value) {
                        return FormValidator.isValidEmail(value);
                      },
                    ),
                  ]
                )
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                child: Text('Send Code'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    sendForgotPassword(context, _email);
                  }
                }
              )
            ],
          );
        }
    );
  }

  Future sendForgotPassword(BuildContext context, String email) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await _auth.instantiateUser(email);
      try {
        String emailSentTo = await _auth.sendForgotPassword(email);
        if (emailSentTo == null) {
          throw new CognitoClientException("Failed to send the forgotten password notification to the server.");
        }
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text("Success"),
                content: Text("An email containing a verification code was sent to " + emailSentTo + "."),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Reset Password"),
                    onPressed: () => goToPasswordRecovery(context),
                  )
                ],
              )
        );
      } on CognitoClientException catch (error) {
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text("Password Recovery Error"),
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

  void goToPasswordRecovery(BuildContext context) {
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PasswordRecoveryPage()));
  }
}
