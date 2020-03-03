import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/page/AboutPage.dart';
import 'package:project_apraxia/page/AmbiancePage.dart';
import 'package:project_apraxia/page/SettingsPage.dart';
import 'package:project_apraxia/page/SelectWaiverPage.dart';
import 'package:project_apraxia/page/HowToPage.dart';
import 'package:project_apraxia/controller/Auth.dart';

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
                          child: Text("Start WSD Calculation",
                              style: TextStyle(fontSize: 20)),
                          onPressed: () => goToRecordPage(context),
                        )),
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
                          child: Text("About", style: TextStyle(fontSize: 20)),
                          onPressed: () => goToAboutPage(context),
                        )),
                    ButtonTheme(
                        minWidth: 250.0,
                        child: RaisedButton(
                          color: Theme.of(context).buttonColor,
                          child: Text("Settings", style: TextStyle(fontSize: 20)),
                          onPressed: () => goToSettingsPage(context),
                        )),
                    ButtonTheme(
                        minWidth: 250.0,
                        child: RaisedButton(
                          color: Theme.of(context).buttonColor,
                          child: Text("Sign Out", style: TextStyle(fontSize: 20)),
                          onPressed: () => signOut(context),
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
  if(Auth.instance().isLoggedIn()) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SelectWaiverPage()));
  }
  else {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) =>
          AmbiancePage(
              wsdCalculator: new LocalWSDCalculator(),
              evalId: "",
          )
    ));
  }
}

void goToSettingsPage(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => SettingsPage()));
}

void goToHowToPage(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => HowToPage()));
}

void goToAboutPage(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => AboutPage()));
}

void signOut(BuildContext context) {
  Auth auth = Auth.instance();
  auth.signOut();
//  TODO: Delete any files generated
  Navigator.pop(context);
}
