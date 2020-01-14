import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:project_apraxia/model/Recording.dart';
import 'package:project_apraxia/widget/PlayButton.dart';

class RecordingsTable extends StatefulWidget {
  final List<Recording> recordings;
  final Recording selectedRecording;
  const RecordingsTable({
    @required this.recordings,
    @required this.selectedRecording,
    Key key,
  }) : super(key: key);

  @override
  _RecordingsTableState createState() =>
      _RecordingsTableState(recordings, selectedRecording);
}

class _RecordingsTableState extends State<RecordingsTable> {
  List<Recording> recordings;
  Recording selectedRecording;
  AudioPlayer audioPlayer;

  _RecordingsTableState(this.recordings, this.selectedRecording);

  @override
  Widget build(BuildContext context) {
    _setDefaultSelection();

    return ListView.builder(
      itemCount: recordings.length,
      itemBuilder: (BuildContext context, int index) {
        Recording recording = recordings[index];
        return _buildRecording(recording);
      },
    );
  }

  void _setDefaultSelection() {
    if (recordings.isNotEmpty && selectedRecording == null){
      setState(() {
        selectedRecording = recordings.first;
      });
    }
  }

  ListTile _buildRecording(Recording recording) {
    return ListTile(
      leading: Radio(
        activeColor: Colors.blue,
        value: recording,
        groupValue: selectedRecording,
        onChanged: (Recording value) {
          setState(() {
            selectedRecording = value;
          });
        },
      ),
      title: Text(recording.name),
      trailing: PlayButton(
        filepath: recording.soundFile.path,
      ),
    );
  }
}
