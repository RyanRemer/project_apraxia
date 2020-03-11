import 'package:flutter/material.dart';

class AppTheme {
  MaterialColor primaryDark;
  Color primary;
  Color primaryLight;
  Color accent;
  IconThemeData iconTheme;
  ButtonThemeData buttonThemeDark;
  ThemeData themeData;

  factory AppTheme.of(BuildContext context){
    return new AppTheme();
  }

  AppTheme() {
    primaryDark = MaterialColor(
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

    primary = Color(0xFF4d6584);
    primaryLight = Color(0xFF99b9d1);
    accent = Color(0xFFFFCB29);

    iconTheme = IconThemeData(
      color: accent,
      opacity: 1.0,
      size: 24.0,
    );

    buttonThemeDark = ButtonThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: primaryDark),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    );

    themeData = ThemeData(
      primarySwatch: primaryDark,
      accentColor: accent,
      toggleableActiveColor: accent,
      iconTheme: iconTheme,
      buttonTheme: buttonThemeDark
    );
  }
}
