import 'package:flutter/material.dart';
import 'package:project_apraxia/widget/form/WaiverSearchForm.dart';

class SearchWaiverPage extends StatefulWidget {
  SearchWaiverPage({Key key}) : super(key: key);

  @override
  _SearchWaiverPageState createState() => _SearchWaiverPageState();
}

class _SearchWaiverPageState extends State<SearchWaiverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search for Waiver"),
      ),
      body: SingleChildScrollView(child: WaiverSearchForm()),
    );
  }
}
