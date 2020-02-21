import 'package:flutter/material.dart';
import 'package:project_apraxia/page/WaiverPage.dart';
import 'package:project_apraxia/widget/form/WaiverSearchForm.dart';

class SelectWaiverPage extends StatelessWidget {
  const SelectWaiverPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Waiver"),
      ),
      body: Column(
        children: <Widget>[
          WaiverSearchForm(),
          RaisedButton(
            child: Text("New HIPAA Waiver"),
            onPressed: () => _goToWaiverPage(context),
          )
        ],
      ),
    );
  }

  void _goToWaiverPage(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return WaiverPage();
    }));
  }
}
