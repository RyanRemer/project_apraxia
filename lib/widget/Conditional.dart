import 'package:flutter/material.dart';

class Conditional extends StatelessWidget {
  final bool condition;
  Widget childIfTrue;
  Widget childIfFalse;

  Conditional({
    @required this.condition,
    @required this.childIfTrue,
    @required this.childIfFalse,
  }) : super(key: ObjectKey(condition));

  @override
  Widget build(BuildContext context) {
    return this.condition ? this.childIfTrue : this.childIfFalse;
  }
}
