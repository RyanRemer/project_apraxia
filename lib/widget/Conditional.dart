import 'package:flutter/material.dart';

class Conditional extends StatelessWidget {
  final bool condition;
  final Widget childIfTrue;
  final Widget childIfFalse;

  Conditional({
    @required this.condition,
    @required this.childIfTrue,
    @required this.childIfFalse,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.condition ? this.childIfTrue : this.childIfFalse;
  }
}
