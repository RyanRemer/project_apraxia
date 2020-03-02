import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_apraxia/controller/LocalFileController.dart';
import 'package:project_apraxia/controller/PromptController.dart';
import 'package:project_apraxia/model/Prompt.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}

class MockLocalFileController extends Mock implements LocalFileController {}

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  MockAudioPlayer audioPlayer = new MockAudioPlayer();
  MockLocalFileController localFileController = new MockLocalFileController();
  MockAssetBundle assetBundle = new MockAssetBundle();
  PromptController promptController = new PromptController(
    audioPlayer: audioPlayer,
    localFileController: localFileController,
    assetBundle: assetBundle
  );

  test("PromptController loads prompts from assetBundle", () async {
    when(assetBundle.load(any)).thenAnswer((_){
      return Future(() => ByteData(0));
    });

    when(assetBundle.loadString(any)).thenAnswer((_){
      return Future(() => "[]");
    });

    await promptController.getPrompts();
    verify(assetBundle.loadString(any)).called(1);
  });

  test("PromptController plays prompt with AudioPlayer", () async {
    await promptController.playPrompt(Prompt(word: "Test", syllableCount: 1, soundUri: "example/uri"));

    when(audioPlayer.play(any)).thenAnswer((_){
      return;
    });

    verify(audioPlayer.play(any)).called(1);
  });

  test("PromptController stops playing with AudioPlayer", () async {
    await promptController.stopPrompt();

    when(audioPlayer.play(any)).thenAnswer((data){
      return;
    });

    verify(audioPlayer.stop()).called(1);
  });
}
