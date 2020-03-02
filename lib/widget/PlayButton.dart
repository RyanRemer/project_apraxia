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
    return FlatButton.icon(
      icon: Icon(Icons.play_circle_filled, size: 32.0,),
      label: Text("Play"),
      onPressed: () => audioPlayer.play(filepath),
    );
  }

  Future<void> play(BuildContext context) async {
    String pathToPlay = filepath;
    if (!pathToPlay.startsWith("file://")) {
      pathToPlay = "file://" + pathToPlay;
    }
    try{
      await audioPlayer.play(pathToPlay);
    }
    catch(error){
      ErrorDialog errorDialog = new ErrorDialog(context);
      errorDialog.show("Error Playing Sound", error.toString());
      throw error;
    }
  }
}