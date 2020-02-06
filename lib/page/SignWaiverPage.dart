import 'package:flutter/material.dart';
import 'package:project_apraxia/widget/form/WaiverForm.dart';

class SignWaiverPage extends StatefulWidget {
  SignWaiverPage({Key key}) : super(key: key);

  @override
  _SignWaiverPageState createState() => _SignWaiverPageState();
}

class _SignWaiverPageState extends State<SignWaiverPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HIPAA Waiver Signature"),
      ),
      body: Column(
        children: <Widget>[
          WaiverForm()
        ],
      )
    );
  }
}
