import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Image.asset("assets/logo/icon.png", height: 150,),
        Image.asset("assets/logo/appraxia.png", height: 50,)
      ],
    );
  }
}
