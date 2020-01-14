import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/PromptController.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/model/Recording.dart';
import 'package:project_apraxia/widget/Conditional.dart';
import 'package:project_apraxia/widget/PageNavigation.dart';
import 'package:project_apraxia/widget/PromptTile.dart';
import 'package:project_apraxia/widget/RecordButton.dart';
import 'package:project_apraxia/widget/RecordingsTable.dart';

class PromptPage extends StatefulWidget {
  final Prompt prompt;
  final PageController pageController;
  final List<Recording> recordings;

  PromptPage(
      {@required this.prompt,
      @required this.pageController,
      @required this.recordings,
      Key key})
      : super(key: key);

  @override
  _PromptPageState createState() =>
      _PromptPageState(this.prompt, this.pageController, this.recordings);
}

class _PromptPageState extends State<PromptPage> {
  Prompt prompt;
  PageController pageController;
  PromptController promptController = new PromptController();
  List<Recording> recordings;
  Recording bestRecording;

  _PromptPageState(this.prompt, this.pageController, this.recordings);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          PromptTile(prompt),
          const Divider(),
          Expanded(
            flex: 2,
            child: RecordingsTable(
              recordings: recordings,
              selectedRecording: bestRecording,
            ),
          ),
          Expanded(
            child: Center(
              child: RecordButton(
                onRecord: addRecording,
              ),
            ),
          ),
          PageNavigation(
            pageController,
            isFirst: promptController.isFirst(prompt),
            isLast: promptController.isLast(prompt),
          )
        ],
      ),
    );
  }

  void addRecording(File soundFile){
    
    Recording recording = new Recording(name:  prompt.word + "-${recordings.length + 1}", );
    recording.soundFile = File(soundFile.parent.path + "/" + recording.name + ".wav");
    soundFile.copySync(recording.soundFile.path);
    
    setState(() {
      recordings.add(recording);
    });
  }
}
