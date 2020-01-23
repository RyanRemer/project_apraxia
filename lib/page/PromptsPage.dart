import 'package:flutter/material.dart';
import 'package:project_apraxia/data/WsdReport.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/model/Recording.dart';
import 'package:project_apraxia/page/PromptArea.dart';
import 'package:project_apraxia/page/ReportsPage.dart';

/// [PromptsPage] is a screen that contains the logic for displaying each of the [Prompt] objects
class PromptsPage extends StatefulWidget {
  final IWSDCalculator wsdCalculator;
  final List<Prompt> prompts;
  final String evaluationId;
  PromptsPage(this.prompts, {@required this.wsdCalculator, Key key, @required this.evaluationId})
      : super(key: key);

  @override
  _PromptsPageState createState() => _PromptsPageState(this.prompts);
}

class _PromptsPageState extends State<PromptsPage> {
  List<Prompt> prompts;
  int index = 0;
  WsdReport wsdReport = new WsdReport();

  _PromptsPageState(this.prompts);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recording Page"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: PromptArea(
              key: ObjectKey(prompts[index]),
              prompt: prompts[index],
              selectedRecording: wsdReport.getRecording(prompts[index]),
              onSelectRecording: (Recording selectedRecording) {
                setState(() {
                  wsdReport.selectRecording(prompts[index], selectedRecording);
                });
              },
            ),
          ),
          _buildNavigation()
        ],
      ),
    );
  }

  Padding _buildNavigation() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RaisedButton(
            child: Text("Previous"),
            onPressed: index > 0 ? _decrementIndex : null,
          ),
          RaisedButton(
            child: Text(isLast() ? "Done" : "Next"),
            onPressed: enableNext()
                ? isLast() ? _moveToReportsPage : _incrementIndex
                : null,
          )
        ],
      ),
    );
  }

  bool enableNext() {
    return wsdReport.getRecording(prompts[index]) != null;
  }

  bool isLast() {
    return index == prompts.length - 1;
  }

  void _decrementIndex() {
    setState(() {
      index--;
    });
  }

  void _incrementIndex() {
    setState(() {
      index++;
    });
  }

  void _moveToReportsPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ReportsPage(
        wsdReport: wsdReport,
        wsdCalculator: widget.wsdCalculator,
        prompts: prompts,
        evaluationId: widget.evaluationId,
      );
    }));
  }
}
