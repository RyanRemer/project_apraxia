import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/controller/RecordController.dart';
import 'package:project_apraxia/page/AmbiancePage.dart';
import 'package:project_apraxia/page/SelectWaiverPage.dart';
import 'package:project_apraxia/widget/form/ActionCard.dart';

class SelectTestPage extends StatefulWidget {
  SelectTestPage({Key key}) : super(key: key);

  @override
  _SelectTestPageState createState() => _SelectTestPageState();
}

class _SelectTestPageState extends State<SelectTestPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Test"),
      ),
      body: ListView(
        children: <Widget>[
          ActionCard(
            title: Text(
              "Local Processing",
              style: Theme.of(context).textTheme.title,
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(" - Test is done on the local device"),
                Text(" - HIPAA waiver is not required"),
                Text(" - Audio processing is limited and less accurate"),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Start Local Test"),
                onPressed: () => _startLocalTest(context),
              )
            ],
          ),
          ActionCard(
            title: Text(
              "Advanced Processing",
              style: Theme.of(context).textTheme.title,
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(" - Audio processing done on a secure server"),
                Text(" - HIPAA waiver is required"),
                Text(" - Client data is shared for research purposes"),
                Text(" - Superior audio processing"),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Select Waiver"),
                onPressed: () => selectWaiver(context),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _startLocalTest(BuildContext context) {
    // remove any recordings that may have slipped by
    RecordController recordController = new RecordController();
    recordController.removeDirectory("recordings");
    
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AmbiancePage(
        wsdCalculator: new LocalWSDCalculator(),
        evalId: "",
      );
    }));
  }

  void selectWaiver(BuildContext context) {
    // remove any recordings that may have slipped by
    RecordController recordController = new RecordController();
    recordController.removeDirectory("recordings");

    Navigator.push(context, MaterialPageRoute( builder: (context){
      return SelectWaiverPage();
    }));
  }
}
