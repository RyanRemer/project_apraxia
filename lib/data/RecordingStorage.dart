import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/model/Recording.dart';

class RecordingStorage {
  Map<Prompt, List<Recording>> recordingMap = new Map();

  static final instance = new RecordingStorage._();
  RecordingStorage._();
  factory RecordingStorage.singleton(){
    return instance;
  }

  List<Recording> getRecordings(Prompt prompt){
    return recordingMap[prompt];
  }

  void updateRecordings(Prompt prompt, List<Recording> recordings){
    recordingMap[prompt] = recordings;
  }
}