import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/PromptController.dart';
import 'package:project_apraxia/model/Prompt.dart';

import 'Conditional.dart';

class PromptTile extends StatefulWidget {
  Prompt prompt;

  PromptTile(this.prompt, {Key key}) : super(key: key);

  @override
  _PromptTileState createState() => _PromptTileState(this.prompt);
}

class _PromptTileState extends State<PromptTile> {
  Prompt prompt;
  PromptController promptController = PromptController();
  AudioPlayerState playerState = AudioPlayerState.STOPPED;

  _PromptTileState(this.prompt){
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
      trailing: Conditional(
        condition: playerState == AudioPlayerState.PLAYING,
        childIfTrue: IconButton(
          icon: Icon(Icons.stop),
          onPressed: promptController.stopPrompt,
        ),
        childIfFalse: IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: () => promptController.playPrompt(prompt),
        ),
      ),
    );
  }
}
