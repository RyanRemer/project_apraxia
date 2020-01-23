import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/WSDCalculator.dart';
import 'package:project_apraxia/page/AmbiancePage.dart';

class WaiverPage extends StatefulWidget {
  WaiverPage({Key key}) : super(key: key);

  @override
  _WaiverPageState createState() => _WaiverPageState();
}

class _WaiverPageState extends State<WaiverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HIPAA Waiver"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("HIPAA Waiver", style: Theme.of(context).textTheme.title,),
          ),
          const Divider(),
          Spacer(),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text("Calculate Locally", style: TextStyle(color: Theme.of(context).hintColor),),
                onPressed: startLocalTest,
              ),
              FlatButton(
                child: Text("Agree To Waiver"),
                onPressed: startRemoteTest,
              )
            ],
          )
        ],
      ),
    );
  }

  void startLocalTest() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return AmbiancePage(
        wsdCalculator: new WSDCalculator(),
      );
    }));
  }

  void startRemoteTest() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return AmbiancePage(
        wsdCalculator: new WSDCalculator(), //TODO: add remote
      );
    }));
  }
}
