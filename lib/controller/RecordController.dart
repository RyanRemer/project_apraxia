import 'package:recorder_wav/recorder_wav.dart';

class RecordController {
  Future startRecording() async {
    RecorderWav.startRecorder();
  }

  /// returns the file uri of the WAV recording
  Future<String> stopRecording() async {
    String filename = await RecorderWav.StopRecorder();
    print("Saved to:" + filename);
    return filename;
  }

  Future removeFile(String filename) async {
    await RecorderWav.removeRecorderFile(filename);
  }
}