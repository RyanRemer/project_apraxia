import 'package:project_apraxia/controller/SafeFile.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/model/Recording.dart';

class RecordingStorage {
  Map<Prompt, List<Recording>> recordingMap = new Map();
  SafeFile ambianceFile;

  static final instance = new RecordingStorage._();
  RecordingStorage._();
  factory RecordingStorage.singleton(){
    return instance;
  }

  SafeFile getAmbianceFile() {
    return ambianceFile;
  }

  void setAmbiance(String fileUri) {
    ambianceFile = new SafeFile(fileUri);
  }

  List<Recording> getRecordings(Prompt prompt){
    return recordingMap[prompt];
  }

  void updateRecordings(Prompt prompt, List<Recording> recordings){
    recordingMap[prompt] = recordings;
  }
}