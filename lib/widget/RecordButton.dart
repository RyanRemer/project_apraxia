import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/RecordController.dart';
import 'package:project_apraxia/controller/WSDCalculator.dart';
import 'package:project_apraxia/widget/Conditional.dart';

class RecordButton extends StatefulWidget {
  @override
  _RecordButtonState createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  RecordController recordController = new RecordController();
  WSDCalculator wsdCalculator = new WSDCalculator();
  bool isRecording = false;
  bool isAmbience = true;
  double ambienceThreshold = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Conditional(
        condition: this.isRecording,
        childIfTrue: Icon(Icons.mic, size: 64, color: Colors.blue,),
        childIfFalse: Icon(Icons.mic_none, size: 64, color: Colors.lightBlueAccent),
      ),
      onTapDown: startRecording,
      onLongPressEnd: stopRecording,
    );
  }

  void startRecording(TapDownDetails details){
    recordController.startRecording();
    Feedback.forLongPress(context);
    setState(() {
      this.isRecording = true;
    });
  }

  Future stopRecording(LongPressEndDetails details) async {
    setState(() {
      this.isRecording = false;
    });
    String fileURI = await recordController.stopRecording();
    // if (this.isAmbience) {
    //   ambienceThreshold = await wsdCalculator.calculateAmbience(fileURI);
    //   this.isAmbience = false;
    // } else {
      wsdCalculator.calculateWSD(fileURI, ambienceThreshold);
    // }
  }
}
