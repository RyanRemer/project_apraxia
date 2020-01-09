import 'dart:developer';
import 'package:project_apraxia/custom_libs/recorder_wav.dart';

class RecordController {
  RecorderWav recorder = new RecorderWav();

  RecordController({this.recorder}){
    recorder ??= new RecorderWav();
  }

  void startRecording() async {
    recorder.startRecorder();
  }

  /// returns the file uri of the WAV recording
  Future<String> stopRecording() async {
    String filename = await recorder.stopRecorder();
    log("Saved to: " + filename);
    return filename;
  }

  Future removeFile(String filename) async {
    await recorder.removeRecorderFile(filename);
  }
}