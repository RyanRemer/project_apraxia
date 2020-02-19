import 'dart:developer';
import 'dart:io';
import 'package:project_apraxia/controller/LocalFileController.dart';
import 'package:project_apraxia/controller/SafeFile.dart';
import 'package:project_apraxia/custom_libs/recorder_wav.dart';

class RecordController {
  RecorderWav recorder = new RecorderWav();
  LocalFileController localFileController = new LocalFileController();

  RecordController({this.recorder}){
    recorder ??= new RecorderWav();
  }

  void startRecording() async {
    recorder.startRecorder();
  }

  /// saves the current recording to [fileUri]
  Future<String> stopRecording(String fileUri) async {
    String recordingUri = await recorder.stopRecorder();
    SafeFile recordingFile = SafeFile(recordingUri);

    String localUri = await localFileController.getLocalRef(fileUri);
    SafeFile(localUri).createSync(recursive: true);
    recordingFile.copySync(localUri);
    recordingFile.deleteSync();

    log("Saved to: " + localUri);
    return localUri;
  }

  Future removeFile(String filename) async {
    await recorder.removeRecorderFile(filename);
  }
}