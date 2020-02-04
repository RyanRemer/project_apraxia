import 'package:flutter/services.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/model/Attempt.dart';

class LocalWSDCalculator extends IWSDCalculator {
  static const channel = const MethodChannel("wsdCalculator");

  @override
  Future<String> setAmbiance(String fileName) async {
    return await channel.invokeMethod("calculateAmbiance", [fileName]);
  }

  @override
  Future<Attempt> addAttempt(String fileName, String word, int syllableCount, String evaluationId) async {
    return Attempt("", await channel.invokeMethod("calculateWSD", [fileName, syllableCount, evaluationId]));
  }

  @override
  Future<List<double>> getAmplitudes(String fileName) async {
    return await channel.invokeMethod("getAmplitude", [fileName]);
  }
}