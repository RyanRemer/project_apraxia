import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/page/AmbiancePage.dart';
import 'package:project_apraxia/page/SettingsPage.dart';
import 'package:project_apraxia/page/SelectWaiverPage.dart';
import 'package:project_apraxia/page/HowToPage.dart';
import 'package:project_apraxia/controller/Auth.dart';
import 'package:project_apraxia/widget/form/Logo.dart';

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
                child: Center(child: Logo()),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 64.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text(
                          "Start WSD Calculation",
                          style: Theme.of(context).primaryTextTheme.headline6,
                        ),
                        onPressed: () => startWSDTest(context),
                      ),
                      RaisedButton(
                        child: Text(
                          "How To",
                          style: Theme.of(context).primaryTextTheme.headline6,
                        ),
                        onPressed: () => goToHowToPage(context),
                      ),
                      RaisedButton(
                        child: Text(
                          "Settings",
                          style: Theme.of(context).primaryTextTheme.headline6,
                        ),
                        onPressed: () => goToSettingsPage(context),
                      ),
                      RaisedButton(
                        child: Text(
                          "Sign Out",
                          style: Theme.of(context).primaryTextTheme.headline6,
                        ),
                        onPressed: () => signOut(context),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

void startWSDTest(BuildContext context) {
  if (Auth.instance().isLoggedIn()) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SelectWaiverPage()));
  } else {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            AmbiancePage(wsdCalculator: new LocalWSDCalculator())));
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
