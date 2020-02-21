import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_apraxia/data/RecordingStorage.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/model/Recording.dart';
import 'package:project_apraxia/widget/PromptTile.dart';
import 'package:project_apraxia/widget/RecordButton.dart';
import 'package:project_apraxia/widget/RecordingsTable.dart';
import 'package:project_apraxia/page/Waveform.dart';

class PromptArea extends StatefulWidget {
  final Prompt prompt;
  final Recording selectedRecording;
  final RecordingSelected onSelectRecording;

  PromptArea({
    Key key,
    @required this.prompt,
    @required this.selectedRecording,
    @required this.onSelectRecording,
  }) : super(key: key);

  @override
  PromptAreaState createState() => PromptAreaState(this.prompt);
}

class PromptAreaState extends State<PromptArea> {
  Prompt prompt;
  List<Recording> _recordings;
  RecordingStorage _recordingStorage = RecordingStorage.singleton();

  PromptAreaState(this.prompt) {
    _recordings = _recordingStorage.getRecordings(prompt) ?? new List();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        PromptTile(prompt),
        const Divider(),
        Expanded(
          flex: 2,
          child: RecordingsTable(
            recordings: _recordings,
            selectedRecording: widget.selectedRecording,
            onSelectRecording: widget.onSelectRecording,
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 8),),
        Expanded(
            child: Waveform(widget.selectedRecording),
          ),
        Expanded(
          child: Center(
            child: RecordButton(
              onRecord: addRecording,
            ),
          ),
        ),
      ],
    ));
  }

  void addRecording(File soundFile) {
    Recording recording = new Recording(
      name: prompt.word + "-${_recordings.length + 1}",
    );

    if (Platform.isAndroid) {
      Directory directory = soundFile.parent;
      recording.soundFile = File("${directory.path}/${recording.name}.wav");
      soundFile.copySync(recording.soundFile.path);
    } else {
      recording.soundFile = soundFile;
    }

    setState(() {
      _recordings.add(recording);
      _recordingStorage.updateRecordings(prompt, _recordings);
    });

    setDefaultSelection();
  }

  void setDefaultSelection() {
    if (_recordings.isNotEmpty){
      widget.onSelectRecording(_recordings.last);
    }
  }
}
