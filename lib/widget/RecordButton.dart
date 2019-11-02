import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/RecordController.dart';
import 'package:project_apraxia/widget/Conditional.dart';

class RecordButton extends StatefulWidget {
  @override
  _RecordButtonState createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  RecordController recordController = new RecordController();
  bool isRecording = false;

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
    print(fileURI);
  }
}
