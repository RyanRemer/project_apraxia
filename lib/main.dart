///
/// Project Apraxia
/// A flutter application for clinicians to measure WSD of patients
///
/// Project Folders
/// page - all the "Pages" which are widgets that have a Scaffold widget
/// widget - the helper widgets
/// controller - the logic controllers
///

import 'package:flutter/material.dart';
import 'package:project_apraxia/page/SignInPage.dart';
import 'package:project_apraxia/widget/AppTheme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppTheme appTheme = new AppTheme();

    return ListTileTheme(
      iconColor: appTheme.accent,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'appraxia',
        theme: appTheme.themeData,
        initialRoute: "/",
        routes: {
          '/' : (context) => SignInPage(),
        },
      ),
    );
  }

}
