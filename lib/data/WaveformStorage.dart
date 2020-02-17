import 'package:project_apraxia/model/Recording.dart';
import 'package:project_apraxia/controller/WSDCalculator.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';

class WaveformStorage {
  Recording currSelectedRecording;
  IWSDCalculator wsdCalculator = new WSDCalculator();

  Future<List<double>> wsdGetAmplitudes(Recording recording) async {
    if(recording == null) {
      return null;
    }
    currSelectedRecording = recording;
    List<double> amplitudes = await wsdCalculator.getAmplitudes(recording.soundFile.path);
    return amplitudes;
  }
}