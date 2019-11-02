import 'package:flutter/material.dart';
import 'package:project_apraxia/widget/RecordButton.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: RecordButton(),
            ),
          )
        ],
      ),
    );
  }
}
