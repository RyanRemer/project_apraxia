import 'package:project_apraxia/custom_libs/recorder_wav.dart';

class RecordController {
  RecorderWav recorder;

  RecordController({this.recorder}){
    recorder ??= new RecorderWav();
  }

  Future startRecording() async {
    await recorder.startRecorder();
  }

  /// returns the file uri of the WAV recording
  Future<String> stopRecording() async {
    String filename = await recorder.stopRecorder();
    print("Saved to: " + filename);
    return filename;
  }

  Future removeFile(String filename) async {
    await recorder.removeRecorderFile(filename);
  }
}