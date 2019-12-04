import 'package:flutter/material.dart';
import 'package:project_apraxia/page/SignUpPage.dart';
import 'package:project_apraxia/widget/form/SignInForm.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Builder(
          builder: (context) => ListView(
            children: <Widget>[
              Container(
                child: SignInForm(),
              ),
              FlatButton(
                child: Text("Sign Up"),
                onPressed: () => goToSignUp(context),
              )
            ],
          ),
        ));
  }

  void goToSignUp(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignUpPage()));
  }
}
