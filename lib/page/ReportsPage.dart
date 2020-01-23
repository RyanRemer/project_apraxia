import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/WSDCalculator.dart';
import 'package:project_apraxia/data/WsdReport.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/model/Attempt.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/widget/ErrorDialog.dart';

class ReportsPage extends StatefulWidget {
  final WsdReport wsdReport;
  final List<Prompt> prompts;
  final IWSDCalculator wsdCalculator;

  ReportsPage(
      {@required this.wsdReport,
      @required this.prompts,
      @required this.wsdCalculator,
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
  Map<Prompt, Attempt> calculatedWSDs;
  IWSDCalculator wsdCalculator;
  double averageWSD;

  _ReportsPageState(this.wsdReport, this.prompts, this.wsdCalculator) {
    loading = false;
    calculatedWSDs = new Map();
    averageWSD = 0.0;

    for (final prompt in prompts) {
      calculatedWSDs[prompt] = new Attempt("", 0.0);
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      calculateWSDs();
    } catch (error) {
      var dialog = new ErrorDialog(context);
      dialog.show("WSD Calculation Error", error.toString());
    }
  }

//  Future setTestAmbiance() async {
//    LocalFileController localFileController = new LocalFileController();
//
//    String localUri = await localFileController.getLocalRef(
//        "assets/prompts/amb.wav");
//
//    await wsdCalculator.setAmbiance(localUri);
//  }

  Future calculateWSDs() async {
    setState(() {
      loading = true;
    });

    // For testing purposes
//    await setTestAmbiance();

    double runningTotal = 0.0;
    for (final prompt in prompts) {
      Attempt newAttempt = await wsdCalculator.addAttempt(
          wsdReport.getRecording(prompt).soundFile.path,
          prompt.word,
          prompt.syllableCount,
          "");
      runningTotal += newAttempt.WSD;
      calculatedWSDs[prompt] = newAttempt;
    }

    // For added dramatic effect
    Future.delayed(new Duration(seconds: 1), () {
      this.setState(() {
        loading = false;
        averageWSD = runningTotal / prompts.length;
      });
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
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(prompts[position].word),
                              Text(calculatedWSDs[prompts[position]]
                                  .WSD
                                  .toStringAsFixed(2))
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

  void completeTest() {}
}
