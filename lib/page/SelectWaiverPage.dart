import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/RemoteWSDCalculator.dart';
import 'package:project_apraxia/page/SurveyPage.dart';
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
      body: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            Align(
              child: Text("Either:", style: Theme.of(context).textTheme.subhead),
              alignment: Alignment.topLeft,
            ),
            Align(
              child: Text(" 1. Search for and select a waiver on file, or", style: Theme.of(context).textTheme.subhead),
              alignment: Alignment.topLeft,
            ),
            Align(
              child: Text(" 2. Sign a new one to proceed.", style: Theme.of(context).textTheme.subhead),
              alignment: Alignment.topLeft,
            ),
            Align(
              child: Text(""),
              alignment: Alignment.topLeft,
            ),
            WaiverSearchForm(onSelect: onWaiverSelected),
            RaisedButton(
              child: Text("New HIPAA Waiver"),
              onPressed: () => _goToWaiverPage(context),
            )
          ],
        ),
      )
    );
  }

  void onWaiverSelected(Map<String, String> waiver, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Waiver Selection"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Are you sure you want to begin a test using the waiver with the following information?"),
            Text(""),
            Text("Name: ${waiver['subjectName']}"),
            Text("Email: ${waiver['subjectEmail']}"),
            Text("Date Signed: ${waiver['date']}")
          ]
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
            }
          ),
          RaisedButton(
            child: Text("Yes"),
            onPressed: () => _goToSurveyPage(context),
          )
        ],
      ),
    );
  }

  void _goToSurveyPage(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return SurveyPage(wsdCalculator: new RemoteWSDCalculator());
    }));
  }

  void _goToWaiverPage(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return WaiverPage();
    }));
  }
}
