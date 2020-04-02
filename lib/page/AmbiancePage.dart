import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/controller/RecordController.dart';
import 'package:project_apraxia/data/RecordingStorage.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/page/RecordPage.dart';
import 'package:project_apraxia/page/Waveform.dart';
import 'package:project_apraxia/widget/AppTheme.dart';
import 'package:project_apraxia/widget/ConfirmationDialog.dart';
import 'package:project_apraxia/widget/ErrorDialog.dart';

import 'Waveform.dart';

class AmbiancePage extends StatefulWidget {
  final IWSDCalculator wsdCalculator;
  final String evalId;
  AmbiancePage({@required this.wsdCalculator, this.evalId, Key key})
      : super(key: key);

  @override
  _AmbiancePageState createState() => _AmbiancePageState(wsdCalculator);
}

class _AmbiancePageState extends State<AmbiancePage> {
  int seconds = 1;
  bool isRecording = false;
  bool ambianceRecorded = false;
  String ambiancePath;
  IWSDCalculator wsdCalculator;

  _AmbiancePageState(this.wsdCalculator);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Record Ambiance"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
                child: Center(
              child: Text(
                  "Press the button below and be quiet for $seconds second."),
            )),
            Container(
              height: 100,
              child: Waveform(
                ambiancePath,
                key: ObjectKey(ambiancePath),
              ),
            ),
            Expanded(
              child: isRecording
                  ? FlatButton(
                      color: AppTheme.of(context).primary,
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () {})
                  : FlatButton(
                      color: AppTheme.of(context).primary,
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: onTap,
                    ),
            ),
            Expanded(
              child: ambianceRecorded
                  ? Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "If there are spikes, record again.\nOtherwise press continue.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        RaisedButton(
                          child: Text("Continue"),
                          onPressed: startTest,
                        ),
                      ],
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }

  void startTest() {
    // remove any recordings that may have slipped by
    RecordController recordController = new RecordController();
    recordController.removeDirectory("recordings");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordPage(
          wsdCalculator: wsdCalculator,
          evaluationId: this.widget.evalId,
        ),
      ),
    );
  }

  Future<void> onTap() async {
    try {
      String fileUri = await recordAmbiance();
      RecordingStorage.singleton().setAmbiance(fileUri);
      await setAmbiance(fileUri);
    } on PlatformException catch (error) {
      ErrorDialog errorDialog = new ErrorDialog(context);
      errorDialog.show("Permission Denied",
          "In order to record the ambiance of the room we need permission to your microphone and storage. Please grant us permission and restart the app.");
      throw error;
    } catch (error) {
      ErrorDialog errorDialog = new ErrorDialog(context);
      errorDialog.show("Error Recording Ambiance", error.toString());
      throw error;
    } finally {
      setState(() {
        isRecording = false;
      });
    }
  }

  Future<String> recordAmbiance() async {
    setState(() {
      isRecording = true;
    });

    RecordController recordController = new RecordController();
    recordController.startRecording();

    await Future.delayed(Duration(seconds: seconds));

    String fileUri =
        await recordController.stopRecording("recordings/ambiance.wav");
    return fileUri;
  }

  Future<void> setAmbiance(String fileUri) async {
    try {
      await wsdCalculator.setAmbiance(fileUri, evalId: widget.evalId);
    } on ServerConnectionException {
      wsdCalculator = new LocalWSDCalculator();
      await wsdCalculator.setAmbiance(fileUri);
      ErrorDialog errorDialog = new ErrorDialog(context);
      errorDialog.show("Error Connecting to Server",
          "The server is currently down. Switching to local processing.");
    } on InternalServerException {
      wsdCalculator = new LocalWSDCalculator();
      await wsdCalculator.setAmbiance(fileUri);
      ErrorDialog errorDialog = new ErrorDialog(context);
      errorDialog.show("Error Connecting to Server",
          "An unexpected server error occurred. Switching to local processing.");
    }

    setState(() {
      ambiancePath = fileUri;
      ambianceRecorded = true;
    });

    return;
  }
}
