import 'package:flutter/material.dart';
import 'package:project_apraxia/page/SignInPage.dart';
import 'package:project_apraxia/widget/form/SignUpForm.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          SignUpForm(),
          FlatButton(
            child: Text("Sign In"),
            onPressed: () => goToSignIn(context),
          )
        ],
      ),
    );
  }

  void goToSignIn(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignInPage()));
  }
}
