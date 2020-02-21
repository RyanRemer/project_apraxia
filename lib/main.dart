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

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      iconColor: accentColor,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: primaryColor,
            accentColor: accentColor,
            toggleableActiveColor: accentColor,
            iconTheme: IconThemeData(
              color: accentColor,
              opacity: 1.0,
              size: 24.0,
            ),
            buttonTheme: ButtonThemeData(
                colorScheme:
                    ColorScheme.fromSwatch(primarySwatch: primaryColor),
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)))),
        home: SignInPage(),
      ),
    );
  }

  MaterialColor get primaryColor {
    return MaterialColor(
      0xFF313D51,
      <int, Color>{
        50: Color(0x00313D51),
        100: Color(0x22313D51),
        200: Color(0x44313D51),
        300: Color(0x66313D51),
        400: Color(0x88313D51),
        500: Color(0xAA313D51),
        600: Color(0xCC313D51),
        700: Color(0xDD313D51),
        800: Color(0xEE313D51),
        900: Color(0xFF313D51),
      },
    );
  }

  Color get accentColor => Color(0xFFFFCB29);
}
