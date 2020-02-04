import 'package:flutter/material.dart';
import 'package:project_apraxia/page/SettingsPage.dart';
import 'package:project_apraxia/page/SelectWaiverPage.dart';
import 'package:project_apraxia/page/HowToPage.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Center(
                  child: const FlutterLogo(
                      size: 500,
                    ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ButtonTheme(
                        minWidth: 250.0,
                        child: RaisedButton(
                          color: Theme.of(context).buttonColor,
                          child: Text("How To", style: TextStyle(fontSize: 20)),
                          onPressed: () => goToHowToPage(context),
                        )),
                    ButtonTheme(
                        minWidth: 250.0,
                        child: RaisedButton(
                          color: Theme.of(context).buttonColor,
                          child: Text("Start WSD Calculation",
                              style: TextStyle(fontSize: 20)),
                          onPressed: () => goToRecordPage(context),
                        )),
                    ButtonTheme(
                        minWidth: 250.0,
                        child: RaisedButton(
                          color: Theme.of(context).buttonColor,
                          child: Text("Settings", style: TextStyle(fontSize: 20)),
                          onPressed: () => goToSettingsPage(context),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

void goToRecordPage(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => SelectWaiverPage()));
}

void goToSettingsPage(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => SettingsPage()));
}

void goToHowToPage(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => HowToPage()));
}
