
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class RecorderWav {
  static const MethodChannel _channel =
      const MethodChannel('recorder_wav');

  Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<String> stopRecorder() async {
    var file = await _channel.invokeMethod("stopRecorder");
    return file;
  }

  void startRecorder() async {
    await _channel.invokeMethod("startRecorder");
  }

  removeRecorderFile(String fileName) async{
    await _channel.invokeMethod("removeFile", {'file': fileName});
  }
}
