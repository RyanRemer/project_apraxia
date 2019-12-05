
import 'dart:async';
import 'dart:io' show Platform;

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
    String uri;
    if (Platform.isAndroid){
      uri = await _channel.invokeMethod("stopRecorder");
    }
    else if (Platform.isAndroid){
      uri = await calculateWSDChannel.invokeMethod("stopRecord");
    }
    return uri;
  }

  void startRecorder() async {
    if (Platform.isAndroid){
      await _channel.invokeMethod("startRecorder");
    }
    else if(Platform.isIOS){
      await calculateWSDChannel.invokeMethod("startRecorder");
    }
  }

  removeRecorderFile(String fileName) async{
    await _channel.invokeMethod("removeFile", {'file': fileName});
  }
}
