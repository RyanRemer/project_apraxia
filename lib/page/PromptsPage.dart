import 'package:flutter/material.dart';
import 'package:project_apraxia/data/WsdReport.dart';
import 'package:project_apraxia/data/WaveformStorage.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/model/Recording.dart';
import 'package:project_apraxia/page/PromptArea.dart';
import 'package:project_apraxia/page/ReportsPage.dart';

/// [PromptsPage] is a screen that contains the logic for displaying each of the [Prompt] objects
class PromptsPage extends StatefulWidget {
  final List<Prompt> prompts;
  PromptsPage(this.prompts, {Key key}) : super(key: key);

  @override
  _PromptsPageState createState() => _PromptsPageState(this.prompts);
}

class _PromptsPageState extends State<PromptsPage> {
  List<Prompt> prompts;
  int index = 0;
  WsdReport wsdReport = new WsdReport();
  WaveformStorage waveformStorage = new WaveformStorage();

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
              key: UniqueKey(),
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
            onPressed:
                enableNext() ? isLast() ? _moveToReportsPage : _incrementIndex : null,
          ),
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => ReportsPage(wsdReport, prompts)));
  }
}
