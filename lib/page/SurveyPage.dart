import 'package:flutter/material.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/widget/form/SurveyForm.dart';

class SurveyPage extends StatefulWidget {
  final IWSDCalculator wsdCalculator;
  SurveyPage({@required this.wsdCalculator, Key key}) : super(key: key);

  @override
  _SurveyPageState createState() => _SurveyPageState(wsdCalculator);
}

class _SurveyPageState extends State<SurveyPage> {
  final IWSDCalculator wsdCalculator;

  _SurveyPageState(this.wsdCalculator);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demographic Survey"),
      ),
      body: Column(
        children: <Widget>[
          SurveyForm(wsdCalculator: wsdCalculator,)
        ],
      )
    );
  }
}
