import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/page/AmbiancePage.dart';
import 'package:project_apraxia/page/SettingsPage.dart';
import 'package:project_apraxia/page/SelectTestPage.dart';
import 'package:project_apraxia/page/HowToPage.dart';
import 'package:project_apraxia/controller/Auth.dart';
import 'package:project_apraxia/widget/Logo.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 64.0,
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Logo(),
              ),
              SizedBox(
                height: 64.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    RaisedButton(
                      child: Text(
                        "Start WSD Calculation",
                        style: Theme.of(context).primaryTextTheme.title,
                      ),
                      onPressed: () => startWSDTest(context),
                    ),
                    RaisedButton(
                      child: Text(
                        "How To",
                        style: Theme.of(context).primaryTextTheme.title,
                      ),
                      onPressed: () => goToHowToPage(context),
                    ),
                    RaisedButton(
                      child: Text(
                        "Settings",
                        style: Theme.of(context).primaryTextTheme.title,
                      ),
                      onPressed: () => goToSettingsPage(context),
                    ),
                    RaisedButton(
                      child: Text(
                        "Sign Out",
                        style: Theme.of(context).primaryTextTheme.title,
                      ),
                      onPressed: () => signOut(context),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

void startWSDTest(BuildContext context) {
  if (Auth.instance().isLoggedIn()) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SelectTestPage()));
  } else {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AmbiancePage(
          wsdCalculator: new LocalWSDCalculator(),
          evalId: "",
        ),
      ),
    );
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

void signOut(BuildContext context) {
  Auth auth = Auth.instance();
  auth.signOut();
//  TODO: Delete any files generated
  Navigator.pop(context);
}