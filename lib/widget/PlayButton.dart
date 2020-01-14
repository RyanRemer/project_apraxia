import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';

class PlayButton extends StatefulWidget {
  final String filepath;
  PlayButton({@required this.filepath, Key key}) : super(key: key);

  @override
  _PlayButtonState createState() => _PlayButtonState(filepath);
}

class _PlayButtonState extends State<PlayButton> {
  AudioPlayer audioPlayer = new AudioPlayer();
  final String filepath;

  _PlayButtonState(this.filepath);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.play_arrow),
      onPressed: () => audioPlayer.play(filepath),
    );
  }
}
