
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class RecorderWav {
  static const MethodChannel _channel =
      const MethodChannel('recorder_wav');
    static const MethodChannel calculateWSDChannel =
    const MethodChannel("wsdCalculator");

  Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<String> stopRecorder() async {
    // var channel = const MethodChannel("wsdCalculator");
    // var file = await _channel.invokeMethod("stopRecorder");
    print("in the dart file recorder_wav stop recorder before");
    // await calculateWSDChannel.invokeMethod("stopRecorder");
    // var file = await calculateWSDChannel.invokeMethod("stopRecord");
    var file = await calculateWSDChannel.invokeMethod("stopRecorder");
    print("in the dart file recorder_wav stop recorder after");
    // return "thisIsATest";
    return file;
  }

  Future<String> stopRecord() async {
    try {
      final String result = await calculateWSDChannel.invokeMethod('stopRecord');
      print('stopRecord: ' + result);
      return result;
    } catch (e) {
      print('stopRecord: fail');
      return 'fail';
    }
  }

  void startRecorder() async {
    // var channel = const MethodChannel("wsdCalculator");
    print("in the start of start recorder before");
    await calculateWSDChannel.invokeMethod("startRecorder");
    print("in the dart file recorder_wav start recorder");
    // await _channel.invokeMethod("startRecorder");
  }

  removeRecorderFile(String fileName) async{
    await _channel.invokeMethod("removeFile", {'file': fileName});
  }
}
