import 'dart:io' show Platform;
import 'package:flutter/services.dart';
//import 'package:project_apraxia/interface/IWSDCalculator.dart';

class WSDCalculator { // extends IWSDCalculator {
  static const channel = const MethodChannel("wsdCalculator");

//  @override
//  Future<String> setAmbiance(String fileName) async {
//    return await channel.invokeMethod("calculateAmbience", [fileName]);
//  }
//
//  @override
//  Future<List> addAttempt(String fileName, String word, int syllableCount, String evaluationId) async {
//    return await channel.invokeMethod("calculateWSD", [fileName, syllableCount, evaluationId]);
//  }
//
//  @override
//  Future<List<double>> getAmplitudes(String fileName) async {
//    return await channel.invokeMethod("getAmplitude", [fileName]);
//  }
  
  Future<double> calculateWSD(String filename, {double ambienceThreshold}) async {
    if (Platform.isAndroid){
      return await channel.invokeMethod("calculateWSD", [filename]);
    }
    else if (Platform.isIOS){
      ambienceThreshold ??= await calculateAmbience(filename);
      return await channel.invokeMethod("calculateWSD", <String, dynamic>{
        'fileName': filename,
        'ambienceThreshold': ambienceThreshold,
      });
    }

    throw PlatformException(message: "Platform Not Supported", code: null);
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