import 'dart:developer';

import 'package:project_apraxia/custom_libs/recorder_wav.dart';

class RecordController {
  RecorderWav recorder = new RecorderWav();

  RecordController({this.recorder}){
    recorder ??= new RecorderWav();
  }

  Future startRecording() async {
    // print("in start recording");
    print("in start recording in da record controller");
    await recorder.startRecorder();
  }

  /// returns the file uri of the WAV recording
  Future<String> stopRecording() async {
    // String filename = await recorder.stopRecorder();
    String filename = await recorder.stopRecord();
    print("SAVED TO WHAT FILE TO THIS FILE to: " + filename);
    log("Saved to: " + filename);
    return filename;
  }

  Future removeFile(String filename) async {
    await recorder.removeRecorderFile(filename);
  }
}