import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/RecordController.dart';
import 'package:project_apraxia/controller/WSDCalculator.dart';
import 'package:project_apraxia/page/RecordPage.dart';

class AmbiancePage extends StatefulWidget {
  AmbiancePage({Key key}) : super(key: key);

  @override
  _AmbiancePageState createState() => _AmbiancePageState();
}

class _AmbiancePageState extends State<AmbiancePage> {
  int seconds = 3;
  bool isRecording = false;
  bool ambienceRecorded = false;
  WSDCalculator wsdCalculator;

  _AmbiancePageState(){
    wsdCalculator ??= new WSDCalculator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Record Ambinace"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Press the button below and be quiet for $seconds seconds."),
            FlatButton(
            color: Colors.red,
            shape: CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Icon(
                isRecording ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 40,
              ),
            ),
            onPressed: onTap,
          ),
          RaisedButton(
            child: Text("Start Test"),
            onPressed: ambienceRecorded ? startTest : null,
          )
          ],
        ),
      ),
    );
  }

  void startTest() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>RecordPage()));
  }

  Future<void> onTap() async {
    String fileUri = await recordAmbiance();
    String evaluationId = await setAmbiance(fileUri);

    // TODO: Figure out what to do with the evaluationId
  }

  Future<String> recordAmbiance() async {
    setState(() {
      isRecording = true;
    });

    RecordController recordController = new RecordController();
    recordController.startRecording();

    await Future.delayed(Duration(seconds: seconds));

    String fileUri = await recordController.stopRecording();

    setState(() {
      isRecording = false;
    });
    return fileUri;
  }

  Future<String> setAmbiance(String fileUri) async {
    WSDCalculator wsdCalculator = new WSDCalculator();
    String evaluationId = await wsdCalculator.setAmbiance(fileUri);
    print(evaluationId);

    setState(() {
      ambienceRecorded = true;
    });

    return evaluationId;
  }
}