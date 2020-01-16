import 'package:flutter/material.dart';

import 'package:project_apraxia/page/RecordPage.dart';
import 'package:project_apraxia/page/UpdateUserPage.dart';
import 'package:project_apraxia/page/HowToPage.dart';

class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FittedBox(
                // fit: BoxFit.contain,
                fit: BoxFit.cover,
                child: const FlutterLogo(),
              ),
            ),
            ButtonTheme(
                minWidth: 250.0,
                child: RaisedButton(
                  child: Text("How To", style: TextStyle(fontSize: 20)),
                  onPressed: () => goToHowToPage(context),
                )
              ),
              ButtonTheme(
                minWidth: 250.0,
                child: RaisedButton(
                  child: Text("Start WSD Calculation", style: TextStyle(fontSize: 20)),
                  onPressed: () => goToRecordPage(context),
                )
              ),
              ButtonTheme(
                minWidth: 250.0,
                child: RaisedButton(
                  child: Text("Settings", style: TextStyle(fontSize: 20)),
                  onPressed: () => goToSettingsPage(context),
                )
              ),
          ],
        )
      );
  }
}

void goToRecordPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecordPage()));
}

void goToSettingsPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateUserPage()));
}

void goToHowToPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HowToPage()));
}