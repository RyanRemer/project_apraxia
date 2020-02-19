import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_apraxia/widget/PlayButton.dart';
import 'package:project_apraxia/widget/RecordButton.dart';

class RecordingFormField extends FormField<String> {
  RecordingFormField({
    String filePath,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
  }) : super(
            initialValue: filePath,
            onSaved: onSaved,
            validator: validator,
            builder: (FormFieldState<String> state) {
              return _RecordingFormField(state);
            });
}

class _RecordingFormField extends StatelessWidget {
  final FormFieldState<String> state;

  _RecordingFormField(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(hasRecorded
              ? "Sound Recorded"
              : "No Sound Recording",
              maxLines: 2,
              ),
          trailing: PlayButton(
            filepath: state.value,
            isEnabled: hasRecorded,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: RecordButton(
            soundUri: state.value,
            onRecord: (File file) {
              state.didChange(file.path);
            },
          ),
        )
      ],
    );
  }

  bool get hasRecorded {
    return File(state.value).existsSync();
  }
}
