import 'package:flutter/material.dart';
import 'package:project_apraxia/page/SignInPage.dart';
import 'package:project_apraxia/widget/form/PasswordRecoveryForm.dart';

class PasswordRecoveryPage extends StatefulWidget {
  @override
  _PasswordRecoveryPageState createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Builder(
          builder: (context) => ListView(
            children: <Widget>[
              Container(
                child: PasswordRecoveryForm(),
              )
            ],
          ),
        ));
  }
}
