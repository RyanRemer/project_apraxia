import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/data/RecordingStorage.dart';
import 'package:project_apraxia/data/WsdReport.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/model/Attempt.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/model/Recording.dart';
import 'package:project_apraxia/widget/ErrorDialog.dart';
import 'package:project_apraxia/widget/PlayButton.dart';

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

    double runningTotal = 0.0;
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
      } on InternalServerException catch(e) {
        wsdCalculator = new LocalWSDCalculator();
        newAttempt = await wsdCalculator.addAttempt(
            selectedRecordings[prompt].soundFile.path,
            prompt.word,
            prompt.syllableCount,
            widget.evaluationId);
        ErrorDialog errorDialog = new ErrorDialog(context);
        errorDialog.show("Internal Server Error", e.message + "\nSwitching to local processing.");
      }

      runningTotal += newAttempt.wsd;
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
    }
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
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
                          child: Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(prompts[position].word),
                                ],
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  DropdownButton<Recording>(
                                      items: RecordingStorage.singleton().getRecordings(prompts[position]).map((Recording value) {
                                        return new DropdownMenuItem<Recording>(
                                          value: value,
                                          child: new Text(value.name),
                                        );
                                      }).toList(),
                                      value: selectedRecordings[prompts[position]],
                                      onChanged: (Recording value) async {
                                        selectedRecordings[prompts[position]] = value;
                                        await calculateWSDs();
                                      }
                                  ),
                                  PlayButton(filepath: selectedRecordings[prompts[position]].soundFile.path),
                                  IconButton(icon: Icon(Icons.clear), onPressed: () {
                                    String promptName = prompts[position].word;
                                    showDialog(context: this.context, builder: (context){
                                      return AlertDialog(
                                        title: Text("Confirmation"),
                                        content: Text("Are you sure you want to delete the prompt for '$promptName' and delete it from the report?"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("No"),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                          FlatButton(
                                            child: Text("Yes"),
                                            onPressed: () async {
                                              await removePrompt(prompts[position]);
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    });
                                  }),
                                  Container(
                                    child: Text(calculatedWSDs[prompts[position]]
                                        .WSD
                                        .toStringAsFixed(2)),
                                    width: 45.0,
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
                      ],
                    )),
                RaisedButton(
                  child: Text("Complete Test"),
                  onPressed: completeTest,
                )
              ],
            ));
  }

  void completeTest() {
    deleteLocalFiles();
    Navigator.pop(context);
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
