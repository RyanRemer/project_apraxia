import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:project_apraxia/model/SignInRequest.dart';
import 'package:project_apraxia/page/PasswordRecoveryPage.dart';
import 'package:project_apraxia/controller/Auth.dart';
import 'package:project_apraxia/page/LandingPage.dart';
import 'package:project_apraxia/page/SignUpPage.dart';

class SignInForm extends StatelessWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey();
  final Auth _auth = new Auth.instance();
  final SignInRequest signInRequest = new SignInRequest.test();

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
          Row(
            children: <Widget>[
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RaisedButton(
                  child: Text("Sign In"),
                  onPressed: () => signIn(context),
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Text("Forgot Password?"),
                onPressed: () => sendForgotPassword(context),
              ),
              FlatButton(
                child: Text("Continue as Guest"),
                onPressed: () => guestLogin(context),
              ),
              FlatButton(
                child: Text("Sign Up"),
                onPressed: () => goToSignUp(context),
              )
            ],
          )
        ],
      ),
    );
  }

  void goToSignUp(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  void guestLogin(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LandingPage()));
  }

  Future signIn(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        await _auth.signIn(signInRequest.email, signInRequest.password);
        Navigator.push(
            // context, MaterialPageRoute(builder: (context) => RecordPage()));
            context,
            MaterialPageRoute(builder: (context) => LandingPage()));
      } on CognitoClientException catch (error) {
        if (error.name == "UserNotConfirmedException") {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Account Unconfirmed"),
              content: Text(
                  "Your account is created but your email is not yet verified. You should have received an email with a verification link in it. Click on the link to verify your email address and then sign in."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Resend Email"),
                  onPressed: () => resendAuthentication(context),
                ),
                RaisedButton(
                  child: Text(
                    "Okay",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          );
        } else {
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

  Future sendForgotPassword(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await _auth.instantiateUser(signInRequest.email);
      try {
        String emailSentTo =
            await _auth.sendForgotPassword(signInRequest.email);
        if (emailSentTo == null) {
          throw new CognitoClientException(
              "Failed to send the forgotten password notification to the server.");
        }
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Success"),
                  content: Text(
                      "An email containing a verification code was sent to " +
                          emailSentTo +
                          "."),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Reset Password"),
                      onPressed: () => goToPasswordRecovery(context),
                    )
                  ],
                ));
      } on CognitoClientException catch (error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PasswordRecoveryPage()));
  }

  void resendAuthentication(BuildContext context) {
    _auth.resendAuthentication(signInRequest.email);
    Navigator.pop(context);
  }
}
