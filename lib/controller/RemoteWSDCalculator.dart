import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/model/Attempt.dart';

class RemoteWSDCalculator extends IWSDCalculator {
  static HttpConnector connector = HttpConnector.instance();

  @override
  Future<void> setAmbiance(String fileName, {String evalId: ""}) async {
    return await connector.setAmbiance(fileName, evalId);
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

  @override
  Future<void> updateAttempt(String evalId, String attemptId, bool active) async {
    return await connector.updateAttempt(evalId, attemptId, active);
  }
}