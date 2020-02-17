import 'package:flutter/services.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/model/Attempt.dart';

class WSDCalculator extends IWSDCalculator {
  static const channel = const MethodChannel("wsdCalculator");
  
  Future<double> calculateWSD(String filename, {double ambianceThreshold}) async {
      return await channel.invokeMethod("calculateWSD", [filename]); 
  }

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
    List<dynamic> amplitudes = await channel.invokeMethod("getAmplitude", [fileName]);
    return List<double>.from(amplitudes);
  }
}