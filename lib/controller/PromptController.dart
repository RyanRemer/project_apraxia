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
    List<Prompt> promptsCopy = List<Prompt>.generate(prompts.length, (index) {
      return Prompt.from(prompts[index]);
    });

    _delocalizeSoundUris(promptsCopy);

    File promptsJsonFile = await getLocalPromptsFile();
    List<dynamic> jsonObject = promptsCopy.map((prompt) => prompt.toMap()).toList();
    String promptsJson = jsonEncode(jsonObject);
    promptsJsonFile.writeAsStringSync(promptsJson);
  }

  /// removes the local file path from each [soundUri] in each of the [Prompt] objects
  /// this is because on iOS the document directory changes each time when the app opens
  /// so we need to reload the document directory every time we load the app
  Future<void> _delocalizeSoundUris(List<Prompt> prompts) async {
    String localPath = await localFileController.getLocalRef("");

    for (Prompt prompt in prompts) {
      prompt.soundUri = prompt.soundUri.substring(localPath.length);
    }
  }

  //get a list of only the prompts have the enabled property as true (determined from settings)
  Future<List<Prompt>> getEnabledPrompts() async {
    List<Prompt> prompts = await getPrompts();
    return prompts.where((prompt) => prompt.enabled).toList();
  }

  /// This is a complex function that returns the list of prompts to the user
  /// It is complex because a user can't edit asset files, so in order to support
  /// custom prompts,  both the asset_prompts.json and the wav files
  /// need to be copied to a local files
  Future<List<Prompt>> getPrompts() async {
    File localFile = await getLocalPromptsFile();

    if (localFile.existsSync() == false) {
      localFile.createSync(recursive: true);
      await _copyAssets(localFile);
    }

    List<Prompt> prompts = _loadPrompts(localFile);
    await _localizeSoundUris(prompts);
    return prompts;
  }

  /// Localizes the [soundUri] of each [Prompt] object
  /// Note: It does not copy the wav file locallay
  Future _localizeSoundUris(List<Prompt> prompts) async {
    for (Prompt prompt in prompts) {
      prompt.soundUri = await localFileController.getLocalRef(prompt.soundUri);
    }
  }

  List<Prompt> _loadPrompts(File file) {
    String jsonString = file.readAsStringSync();
    List<dynamic> jsonMaps = jsonDecode(jsonString);

    return List.generate(jsonMaps.length, (index) {
      return Prompt.fromMap(jsonMaps[index]);
    });
  }

  /// Reloads the prompts by deleting the local_prompts.json and
  /// reimporting the prompts
  Future<List<Prompt>> reloadPrompts() async {
    File localFile = await getLocalPromptsFile();
    localFile.deleteSync();
    return getPrompts();
  }

  /// Copies the asset_prompts.json in the asset folder to [localFile]
  /// Then all of the [soundUri] in asset_prompts.json is copied over to
  /// a local file so that it can be played with the [AudioPlayer] and edited locally
  ///
  /// Note that the [localFile] will not contain the [ApplicationDocumentDirectory]
  /// because iOS devices change the [NSDocumentDirectory] every time the app opens,
  /// meaning that if you stored absolute file paths that the next time the app opened
  /// that none of the file paths would work
  Future<void> _copyAssets(File localFile) async {
    // copy the jsonString
    String jsonString = await getAssetJson();
    localFile.writeAsStringSync(jsonString);

    // copy the sound files to the local directory
    List<Prompt> assets = await _getAssets();
    for (Prompt asset in assets) {
      ByteData soundData = await assetBundle.load(asset.soundUri);
      File localSoundFile =
          await localFileController.getLocalFile(asset.soundUri);
      localSoundFile.createSync(recursive: true);
      localSoundFile.writeAsBytesSync(Int8List.view(soundData.buffer));
    }
  }

  Future<List<Prompt>> _getAssets() async {
    String jsonString = await getAssetJson();
    List<dynamic> jsonMaps = jsonDecode(jsonString);
    return List<Prompt>.generate(jsonMaps.length, (index) {
      return Prompt.fromMap(jsonMaps[index]);
    });
  }

  Future<File> getLocalPromptsFile() async {
    return localFileController.getLocalFile("prompts/local_prompts.json");
  }

  Future<String> getAssetJson() async {
    return await assetBundle.loadString("assets/prompts/asset_prompts.json");
  }
}
