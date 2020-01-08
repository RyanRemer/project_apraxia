import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/RecordController.dart';
import 'package:project_apraxia/widget/ErrorDialog.dart';

typedef RecordCallback = void Function(File soundFile);

/// A circular button with a microphone that records audio from the device into a device folder
class RecordButton extends StatefulWidget {
  /// After each recording call this function with the [File] with the audio information
  final RecordCallback onRecord;

  RecordButton({@required this.onRecord, Key key}) : super(key: key);

  @override
  _RecordButtonState createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  RecordController recordController;
  bool isRecording = false;

  _RecordButtonState({this.recordController, this.isRecording = false}) {
    this.recordController ??= new RecordController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(isRecording ? "Tap to Stop" : "Tap to Record"),
        ),
      ],
    );
  }

  Future<void> onTap() async {
    await recordAudio();
    setState(() {
      isRecording = !isRecording;
    });
  }

  Future recordAudio() async {
    try {

      if (isRecording) {
        String fileUri = await recordController.stopRecording();
        widget.onRecord(File(fileUri)); //send the file to the callback function
      } else {
        await recordController.startRecording();
      }
      
    } catch (error) {
      var dialog = new ErrorDialog(context);
      dialog.show("Recording Error", error.toString());
    }
  }
}
