import 'package:flutter/material.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/model/Recording.dart';

class RecordingsTable extends StatefulWidget {
  const RecordingsTable({Key key}) : super(key: key);

  @override
  _RecordingsTableState createState() => _RecordingsTableState();
}

class _RecordingsTableState extends State<RecordingsTable> {
  Prompt prompt = Prompt(word: "Gingerbread", syllableCount: 3);
  List<Recording> recordings = [
    Recording(name: "Recording-1"),
    Recording(name: "Recording-2"),
    Recording(name: "Recording-3")
  ];
  Recording selectedRecording;

  @override
  Widget build(BuildContext context) {
    return _buildOption2();
  }

  Widget _buildOption1() {
    return ListView.builder(
      itemCount: recordings.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Radio(
            activeColor: Colors.blue,
            value: recordings[index],
            groupValue: recordings[0], onChanged: (Recording value) {},
          ),
          title: Text(recordings[index].name),
          trailing: IconButton(icon: Icon(Icons.play_arrow), onPressed: (){},),
        );
      },
    );
  }

  Widget _buildOption2() {
    return ListView.builder(
      itemCount: recordings.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
          Checkbox(
            value: index == 0,
            activeColor: Colors.blue, onChanged: (bool value) {},
          ),
          Text(recordings[index].name),
          Text("WSD: 320"),
          IconButton(icon: Icon(Icons.play_arrow), onPressed: (){},),
          ],
        );
      },
    );
  }

  
}
