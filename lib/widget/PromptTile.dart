import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/PromptController.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/widget/PlayButton.dart';

class PromptTile extends StatefulWidget {
  final Prompt prompt;
  PromptTile(this.prompt, {Key key}) : super(key: key);

  @override
  _PromptTileState createState() => _PromptTileState(this.prompt);
}

class _PromptTileState extends State<PromptTile> {
  Prompt prompt;
  PromptController promptController = PromptController();
  AudioPlayerState playerState = AudioPlayerState.STOPPED;

  _PromptTileState(this.prompt){
    if (prompt == null){
      throw ArgumentError.notNull("prompt must not be null");
    }

    promptController.audioPlayer.onPlayerStateChanged.listen((state){
      setState(() {
        this.playerState = state;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(prompt.word),
      subtitle: Text("Syllables: ${prompt.syllableCount}"),
      trailing:PlayButton(filepath: prompt.soundUri,)
    );
  }
}
