import 'package:flutter/material.dart';
import 'package:project_apraxia/widget/Logo.dart';
import 'package:project_apraxia/widget/form/SignInForm.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
          builder: (context) => ListView(
            children: <Widget>[
              SizedBox(
                height: 64.0,
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Logo(),
              ),
              SignInForm(),
            ],
          ),
        ));
  }
}
