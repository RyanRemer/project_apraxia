import 'package:flutter/material.dart';
import 'package:project_apraxia/widget/form/SignUpForm.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: ListView(
        children: <Widget>[
          SignUpForm(),
        ],
      ),
    );
  }
}
