import 'package:flutter/material.dart';
import 'package:project_apraxia/page/SearchWaiverPage.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 64.0),
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RaisedButton(
                  child: Text("Search for HIPAA Waiver"),
                  onPressed: () => _goToSearchPage(context),
                ),
                RaisedButton(
                  child: Text("Create New HIPAA Waiver"),
                  onPressed: () => _goToWaiverPage(context),
                ),
              ],
            ),
      ),
    );
  }

  void _goToWaiverPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WaiverPage();
    }));
  }

  void _goToSearchPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SearchWaiverPage();
    }));
  }
}
