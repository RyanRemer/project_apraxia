import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/model/Recording.dart';

class WsdReport {
  Map<Prompt, Recording> selectedRecordingMap = new Map();

  void selectRecording(Prompt prompt, Recording recording){
    selectedRecordingMap[prompt] = recording;
  }
}