import 'package:flutter/material.dart';
import 'package:project_apraxia/model/SignInRequest.dart';
import 'package:project_apraxia/widget/auth.dart';
import 'package:project_apraxia/widget/form/SignInForm.dart';
import 'package:project_apraxia/widget/form/SignUpForm.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              Divider(),
              Container(
                child: SignUpForm(),
              )
            ],
          ),
        ));
  }
}
