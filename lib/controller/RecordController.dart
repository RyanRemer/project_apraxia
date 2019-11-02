import 'package:recorder_wav/recorder_wav.dart';

class RecordController {
  Future startRecording() async {
    RecorderWav.startRecorder();
  }

  /// returns the file uri of the WAV recording
  Future<String> stopRecording() async {
    return await RecorderWav.StopRecorder();
  }
}