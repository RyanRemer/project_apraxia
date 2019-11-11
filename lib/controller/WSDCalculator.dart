import 'package:flutter/services.dart';

class WSDCalculator {
  static const channel = const MethodChannel("wsdCalculator");

  Future<double> calculateWSD(String filename) async {
    return await channel.invokeMethod("calculateWSD", [filename]);
  }

  Future<List<double>> getAmplitude(String filename) async {
    return await channel.invokeMethod("getAmplitude", [filename]);
  }
}