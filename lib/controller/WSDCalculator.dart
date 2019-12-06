import 'package:flutter/services.dart';

class WSDCalculator {
  static const channel = const MethodChannel("wsdCalculator");

  Future<double> calculateWSD(String filename, double ambienceThreshold) async {
    // print("in calculate wsd hello");
    return await channel.invokeMethod("calculateWSD", [filename]);
    // this is commented out but need it
    // return await channel.invokeMethod("calculateWSD", <String, dynamic>{
    //     'fileName': filename,
    //     'ambienceThreshold': ambienceThreshold,
    //   });
  }

  Future<double> calculateAmbience(String filename) async {
    // print("in calculate wsd hello");
    double ambience = await channel.invokeMethod("calculateAmbience", [filename]);
    return ambience;
    // return await channel.invokeMethod("calculateAmbience", [filename]);
  }

  Future<List<double>> getAmplitude(String filename) async {
    return await channel.invokeMethod("getAmplitude", [filename]);
  }
}