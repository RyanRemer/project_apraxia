import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_apraxia/controller/RecordController.dart';
import 'package:recorder_wav/recorder_wav.dart';

class MockRecorder extends Mock implements RecorderWav{}

void main(){
  test("RecordController can start recording", () async {
    MockRecorder mockRecorder = new MockRecorder();
    RecordController recordController = new RecordController(recorder: mockRecorder);
    String filename = "recorder.wav";

    when(mockRecorder.startRecorder()).thenAnswer((_) async{
      return null;
    });

    recordController.startRecording();

    verify(mockRecorder.startRecorder()).called(1);
  });

  test("RecordController should create a .wav file", () async {
    MockRecorder mockRecorder = new MockRecorder();
    RecordController recordController = new RecordController(recorder: mockRecorder);

    when(mockRecorder.stopRecorder()).thenAnswer((_) async{
      return "test.wav";
    });

    String filename = await recordController.stopRecording();
    expect(filename, "test.wav");
  });

  test("RecordController can delete a file", () async {
    MockRecorder mockRecorder = new MockRecorder();
    RecordController recordController = new RecordController(recorder: mockRecorder);
    String filename = "recorder.wav";

    when(mockRecorder.removeRecorderFile(filename)).thenAnswer((_) async{
      return null;
    });

    recordController.removeFile(filename);

    verify(mockRecorder.removeRecorderFile(filename)).called(1);
  });
}