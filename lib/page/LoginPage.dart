import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text("email"),
            )
          ),
          Expanded(
              child: Center(
                child: TextField(),
              )
          ),
          Expanded(
              child: Center(
                child: Text("password"),
              )
          ),
          Expanded(
              child: Center(
                child: TextField(),
              )
          )
        ],
      ),
    );
  }
}