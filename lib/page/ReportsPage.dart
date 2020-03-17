import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/controller/RemoteWSDCalculator.dart';
import 'package:project_apraxia/data/RecordingStorage.dart';
import 'package:project_apraxia/data/WsdReport.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/model/Attempt.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/model/Recording.dart';
import 'package:project_apraxia/widget/ErrorDialog.dart';
import 'package:project_apraxia/widget/PlayButton.dart';
import 'package:project_apraxia/widget/SendReportButton.dart';

class ReportsPage extends StatefulWidget {
  final WsdReport wsdReport;
  final List<Prompt> prompts;
  final IWSDCalculator wsdCalculator;
  final String evaluationId;

  ReportsPage(
      {@required this.wsdReport,
      @required this.prompts,
      @required this.wsdCalculator,
      @required this.evaluationId,
      Key key})
      : super(key: key);

  @override
  _ReportsPageState createState() =>
      _ReportsPageState(this.wsdReport, this.prompts, this.wsdCalculator);
}

class _ReportsPageState extends State<ReportsPage> {
  WsdReport wsdReport;
  bool loading;
  List<Prompt> prompts;
  Map<Prompt, Recording> selectedRecordings;
  Map<Prompt, Attempt> calculatedWSDs;
  IWSDCalculator wsdCalculator;
  double averageWSD;
  double runningTotal = 0.0;
  int numPrompts = 0;

  _ReportsPageState(this.wsdReport, this.prompts, this.wsdCalculator) {
    loading = false;
    calculatedWSDs = new Map();
    selectedRecordings = new Map();
    averageWSD = 0.0;

    for (final prompt in prompts) {
      calculatedWSDs[prompt] = new Attempt("", 0.0);
      selectedRecordings[prompt] = wsdReport.getRecording(prompt);
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      calculateWSDs();
    } catch (error) {
      ErrorDialog dialog = new ErrorDialog(context);
      dialog.show("WSD Calculation Error", error.toString());
    }
  }

  Future calculateWSDs() async {
    setState(() {
      loading = true;
    });

    for (final prompt in prompts) {
      Attempt newAttempt;
      try {
        newAttempt = await wsdCalculator.addAttempt(
            selectedRecordings[prompt].soundFile.path,
            prompt.word,
            prompt.syllableCount,
            widget.evaluationId);
      } on ServerConnectionException {
        wsdCalculator = new LocalWSDCalculator();
        newAttempt = await wsdCalculator.addAttempt(
            selectedRecordings[prompt].soundFile.path,
            prompt.word,
            prompt.syllableCount,
            widget.evaluationId);
        ErrorDialog errorDialog = new ErrorDialog(context);
        errorDialog.show("Error Connecting to Server",
            "The server is currently down. Switching to local processing.");
      } on InternalServerException catch (e) {
        wsdCalculator = new LocalWSDCalculator();
        newAttempt = await wsdCalculator.addAttempt(
            selectedRecordings[prompt].soundFile.path,
            prompt.word,
            prompt.syllableCount,
            widget.evaluationId);
        ErrorDialog errorDialog = new ErrorDialog(context);
        errorDialog.show("Internal Server Error",
            e.message + "\nSwitching to local processing.");
      }

      runningTotal += newAttempt.wsd;
      numPrompts++;
      calculatedWSDs[prompt] = newAttempt;
    }

    // For added dramatic effect if it's running locally
    if (wsdCalculator is LocalWSDCalculator) {
      Future.delayed(new Duration(seconds: 1), () {
        this.setState(() {
          loading = false;
          averageWSD = runningTotal / prompts.length;
        });
      });
    } else {
      this.setState(() {
        loading = false;
        averageWSD = runningTotal / prompts.length;
      });
    }

    this.setState(() {
      loading = false;
      averageWSD = runningTotal / prompts.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
            appBar: AppBar(
              title: Text("Reports Page"),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  CircularProgressIndicator(),
                  Text("Loading Reports...")
                ])))
        : Scaffold(
            appBar: AppBar(
              title: Text("Reports Page"),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: ListView.builder(
                    itemBuilder: (context, position) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
                          child: Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Checkbox(
                                    value: prompts[position].enabled,
                                    onChanged: (val) {
                                      setState(() {
                                        recalculateWSD(position, val);
                                      });
                                    },
                                  ),
                                  Text(prompts[position].word),
                                ],
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  PlayButton(
                                      filepath:
                                          selectedRecordings[prompts[position]]
                                              .soundFile
                                              .path),
                                  Container(
                                    child: Text(
                                        calculatedWSDs[prompts[position]]
                                            .wsd
                                            .toStringAsFixed(2),
                                      textAlign: TextAlign.end,
                                    ),
                                    width: 60.0,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: prompts.length,
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Average WSD",
                              style: TextStyle(fontSize: 24)),
                        ),
                        Text(
                          averageWSD.toStringAsFixed(2),
                          style: TextStyle(fontSize: 36),
                        ),
                        checkIfBackend()
                      ],
                    )),
                
              ],
            ));
  }

  Widget checkIfBackend() {
    if (wsdCalculator is RemoteWSDCalculator) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Spacer(),
        RaisedButton(
          child: Text("Complete Test"),
          onPressed: completeTest,
        ),
        Spacer(),
        SendReportButton(
          evalId: widget.evaluationId,
        ),
        Spacer()
      ]);
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        RaisedButton(
          child: Text("Complete Test"),
          onPressed: completeTest,
        )
      ]);
    }
  }

  void completeTest() {
    deleteLocalFiles();
    Navigator.pop(context);
  }

  Future<void> removePrompt(Prompt prompt) async {
    RecordingStorage _recordingStorage = RecordingStorage.singleton();
    for (Recording recording in _recordingStorage.getRecordings(prompt)) {
      recording.soundFile.deleteSync();
    }
    _recordingStorage.updateRecordings(prompt, []);
    calculatedWSDs.remove(prompt);
    selectedRecordings.remove(prompt);
    prompts.remove(prompt);
    calculateWSDs();
  }

  Future<void> updateAttempt(Attempt attempt, bool included) async {
    return wsdCalculator.updateAttempt(
        widget.evaluationId, attempt.attemptId, included);
  }

  void recalculateWSD(int position, bool val) {
    prompts[position].enabled = val;
    try {
      updateAttempt(calculatedWSDs[prompts[position]],prompts[position].enabled);
    } on ServerConnectionException {
      ErrorDialog errorDialog = new ErrorDialog(context);
      errorDialog.show("Error Connecting to Server",
          "The server is currently down. Switching to local processing.");
    } on InternalServerException catch (e) {
      ErrorDialog errorDialog = new ErrorDialog(context);
      errorDialog.show("Internal Server Error",
          e.message + "\nSwitching to local processing.");
    }
    if (prompts[position].enabled == true) {
      runningTotal += calculatedWSDs[prompts[position]].wsd;
      numPrompts++;
      averageWSD = runningTotal / numPrompts;
    } else {
      runningTotal -= calculatedWSDs[prompts[position]].wsd;
      numPrompts--;
      averageWSD = runningTotal / numPrompts;
    }
  }

  void deleteLocalFiles() {
    RecordingStorage _recordingStorage = RecordingStorage.singleton();
    _recordingStorage.getAmbianceFile().deleteSync();
    for (Prompt prompt in prompts) {
      for (Recording recording in _recordingStorage.getRecordings(prompt)) {
        recording.soundFile.deleteSync();
      }
      _recordingStorage.updateRecordings(prompt, []);
    }
  }
}
