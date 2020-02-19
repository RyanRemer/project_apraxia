import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:project_apraxia/model/Recording.dart';
import 'package:project_apraxia/widget/PlayButton.dart';

typedef RecordingSelected = void Function(Recording);

class RecordingsTable extends StatefulWidget {
  final List<Recording> recordings;
  final Recording selectedRecording;
  final RecordingSelected onSelectRecording;

  const RecordingsTable({
    @required this.recordings,
    @required this.selectedRecording,
    @required this.onSelectRecording,
    Key key,
  }) : super(key: key);

  @override
  _RecordingsTableState createState() => _RecordingsTableState(recordings);
}

class _RecordingsTableState extends State<RecordingsTable> {
  List<Recording> recordings;
  AudioPlayer audioPlayer;

  _RecordingsTableState(this.recordings);

  @override
  Widget build(BuildContext context) {
    if (recordings.isEmpty){
      return Center(child: Text("Record at least one attempt to continue."),);
    }

    return ListView.builder(
      itemCount: recordings.length,
      itemBuilder: (BuildContext context, int index) {
        Recording recording = recordings[index];
        return _buildRecording(recording);
      },
    );
  }

  ListTile _buildRecording(Recording recording) {
    return ListTile(
      leading: Radio(
        activeColor: Colors.blue,
        value: recording,
        groupValue: widget.selectedRecording,
        onChanged: (Recording value) {
          widget.onSelectRecording(value);
        },
      ),
      title: Text(recording.name),
      trailing: PlayButton(
        filepath: recording.soundFile.prefixPath,
      ),
    );
  }
}
