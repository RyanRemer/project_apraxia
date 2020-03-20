import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/RemoteWSDCalculator.dart';
import 'package:project_apraxia/page/SurveyPage.dart';
import 'package:project_apraxia/widget/form/WaiverSearchForm.dart';

class SearchWaiverPage extends StatefulWidget {
  SearchWaiverPage({Key key}) : super(key: key);

  @override
  _SearchWaiverPageState createState() => _SearchWaiverPageState();
}

class _SearchWaiverPageState extends State<SearchWaiverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search for Waiver"),
      ),
      body: SingleChildScrollView(
        child: WaiverSearchForm(
          onSelect: onWaiverSelected,
        ),
      ),
    );
  }

  Future<void> onWaiverSelected(
      Map<String, String> waiver, BuildContext context) async {
    bool beginTest = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Waiver Selection"),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  "Are you sure you want to begin a test using the waiver with the following information?"),
              Text(""),
              Text("Name: ${waiver['subjectName']}"),
              Text("Email: ${waiver['subjectEmail']}"),
              Text("Date Signed: ${waiver['date']}")
            ]),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          RaisedButton(
            child: Text("Yes"),
            onPressed: () => Navigator.of(context).pop(true),
          )
        ],
      ),
    );

    if (beginTest){
      _goToSurveyPage(context);
    }
  }

  void _goToSurveyPage(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return SurveyPage(wsdCalculator: new RemoteWSDCalculator());
    }));
  }
}
