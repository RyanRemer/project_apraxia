import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:project_apraxia/widget/ErrorDialog.dart';

class PlayButton extends StatelessWidget {
  static AudioPlayer audioPlayer = new AudioPlayer();
  final String filepath;
  final bool isEnabled;

  const PlayButton({@required this.filepath, this.isEnabled = true, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.play_arrow),
      onPressed: isEnabled ? () => play(context) : null,
    );
  }

  Future<void> play(BuildContext context) async {
    try{
      await audioPlayer.play(filepath);
    }
    catch(error){
      ErrorDialog errorDialog = new ErrorDialog(context);
      errorDialog.show("Error Playing Sound", error.toString());
      throw error;
    }
  }
}