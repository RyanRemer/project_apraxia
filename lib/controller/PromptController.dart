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

  PromptController({
    this.audioPlayer,
    this.localFileController,
    this.assetBundle,
  }) {
    this.audioPlayer ??= new AudioPlayer();
    this.localFileController ??= new LocalFileController();
    this.assetBundle ??= rootBundle;
  }

  /// save prompts to the local storage on the device
  Future<void> savePrompts(List<Prompt> prompts) async {
    File promptsJsonFile = await getLocalPromptsJson();
    List<dynamic> jsonObject = prompts.map((prompt) => prompt.toMap()).toList();
    String promptsJson = jsonEncode(jsonObject);
    promptsJsonFile.writeAsStringSync(promptsJson);
  }

  //get a list of only the prompts have the enabled property as true (determined from settings)
  Future<List<Prompt>> getEnabledPrompts() async {
    List<Prompt> prompts = await getPrompts();
    return prompts.where((prompt) => prompt.enabled).toList();
  }

  /// This is a complex function that returns the list of prompts to the user
  /// It is complex because 
  Future<List<Prompt>> getPrompts() async {
    await _copyAssetPromptsJson();
    await _copyAssetPromptSoundFiles();

    File promptsJsonFile = await getLocalPromptsJson();
    String promptsJson = promptsJsonFile.readAsStringSync();
    List<dynamic> jsonObject = jsonDecode(promptsJson);

    return List.generate(jsonObject.length, (index) {
      return Prompt.fromMap(jsonObject[index]);
    });
  }

  Future<List<Prompt>> reloadPromptsFromAssets() async {
    File localFile = await getLocalPromptsJson();
    localFile.deleteSync();
    return getPrompts();
  }

  // copies the local_prompts.json file if it does not exist localy
  Future _copyAssetPromptsJson() async {
    File localFile = await getLocalPromptsJson();

    if (localFile.existsSync() == false) {
      List<Prompt> localizedAssetPrompts = await _getLocalizedAssetPrompts();
      List<dynamic> jsonObject =
          localizedAssetPrompts.map((prompt) => prompt.toMap()).toList();
      String promptsJson = jsonEncode(jsonObject);
      localFile.createSync(recursive: true);
      localFile.writeAsStringSync(promptsJson);
    }
  }

  // returns a list of prompts with localized soundUris
  Future<List<Prompt>> _getLocalizedAssetPrompts() async {
    List<Prompt> assetPrompts = await _getPromptAssets();
    for (Prompt prompt in assetPrompts) {
      prompt.soundUri = await localFileController.getLocalRef(prompt.soundUri);
    }
    return assetPrompts;
  }

  // saves all the prompt's uris to a local directory for playback
  Future _copyAssetPromptSoundFiles() async {
    List<Prompt> assetPrompts = await _getPromptAssets();
    for (Prompt prompt in assetPrompts) {
      if (prompt.soundUri == null) {
        throw Exception("SoundUri for ${prompt.word} is null");
      }

      ByteData byteData = await assetBundle.load(prompt.soundUri);
      File localFile = await localFileController.getLocalFile(prompt.soundUri);
      localFile.createSync(recursive: true);

      localFile.writeAsBytesSync(Int8List.view(byteData.buffer));
      prompt.soundUri = localFile.path;
    }
  }

  // load all of the prompts specified in the assets/prompts/asset_prompts.json file
  Future<List<Prompt>> _getPromptAssets() async {
    String promptJson = await getAssetPromptsJson();
    var jsonMap = json.decode(promptJson);

    return List.generate(jsonMap.length, (int i) {
      return Prompt.fromMap(jsonMap[i]);
    });
  }

  Future<File> getLocalPromptsJson() async {
    return localFileController.getLocalFile("prompts/local_prompts.json");
  }

  Future<String> getAssetPromptsJson() async {
    return await assetBundle.loadString("assets/prompts/asset_prompts.json");
  }
}
