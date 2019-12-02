import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:project_apraxia/controller/LocalFileController.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:audioplayer/audioplayer.dart';

typedef PromptListener = void Function(Prompt);

class PromptController {
  LocalFileController localFileController;
  AudioPlayer audioPlayer;
  AssetBundle assetBundle;
  static List<Prompt> prompts;

  PromptController({this.audioPlayer, this.localFileController, this.assetBundle}){
    this.audioPlayer ??= new AudioPlayer();
    this.localFileController ??= new LocalFileController();
    this.assetBundle ??= rootBundle;
  }

  /// Loads prompts from the [AssentBundle] and saves them in a
  /// local device directory so that the AudioPlayer can play them
  Future<List<Prompt>> getPrompts() async {
    if (prompts == null) {
      prompts = await _getPromptAssets();
      await _writePromptsToLocal(prompts);
    }
    return prompts;
  }

  // saves all the prompt's uris to a local directory for playback
  Future _writePromptsToLocal(List<Prompt> prompts) async {
    for (Prompt prompt in prompts) {
      if (prompt.soundUri == null) {
        continue;
      }

      String localUri = await localFileController.getLocalRef(prompt.soundUri);
      ByteData byteData = await assetBundle.load(prompt.soundUri);

      localFileController.createFile(localUri);
      File localFile = localFileController.getFile(localUri);

      localFile.writeAsBytesSync(Int8List.view(byteData.buffer));
      prompt.soundUri = localFile.uri.toString();
    }
  }

  // load all of the prompts specified in the assets/prompts/local_prompts.json file
  Future<List<Prompt>> _getPromptAssets() async {
    String promptJson =
        await assetBundle.loadString("assets/prompts/local_prompts.json");
    var jsonMap = json.decode(promptJson);

    return List.generate(jsonMap.length, (int i) {
      return Prompt.fromMap(jsonMap[i]);
    });
  }

  Future playPrompt(Prompt prompt) async {
    if (prompt.soundUri != null){
      await audioPlayer.play(prompt.soundUri);
    } else {
      print("Prompt has no soundUri, cannot play it");
    }
  }

  Future stopPrompt() async {
    await audioPlayer.stop();
  }

  bool isFirst(Prompt prompt){
    return prompt == prompts.first;
  }

  bool isLast(Prompt prompt){
    return prompt == prompts.last;
  }
}
