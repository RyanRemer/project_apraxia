import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/Auth.dart';
import 'package:project_apraxia/widget/form/SignUpForm.dart';

class UpdateUserPage extends StatefulWidget {
  @override
  _UpdateUserPageState createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          SignUpForm(),
          FlatButton(
            child: Text("Go Back"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
