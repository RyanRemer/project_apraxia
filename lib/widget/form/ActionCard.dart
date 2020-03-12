import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Widget title;
  final Widget content;
  final List<Widget> actions;
  const ActionCard({
    Key key,
    this.margin = const EdgeInsets.all(16.0),
    this.padding = const EdgeInsets.all(16.0),
    @required this.title,
    @required this.content,
    this.actions = const <Widget>[],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Card(
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              title,
              const Divider(),
              content,
              ButtonBar(
                children: actions
              )
            ],
          ),
        ),
      ),
    );
  }
}
