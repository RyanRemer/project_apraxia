import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/model/Attempt.dart';

class RemoteWSDCalculator extends IWSDCalculator {
  static HttpConnector connector = HttpConnector.instance();

  @override
  Future<String> setAmbiance(String fileName) async {
    return await connector.setAmbiance(fileName);
  }

  @override
  Future<Attempt> addAttempt(String fileName, String word, int syllableCount, String evaluationId) async {
    return await connector.addAttempt(fileName, word, syllableCount, evaluationId);
  }

  @override
  Future<List<double>> getAmplitudes(String fileName) async {
    IWSDCalculator calculator = new LocalWSDCalculator();
    return calculator.getAmplitudes(fileName);
  }
}