import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/SafeFile.dart';
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
          title: Text(state.value ?? "No Sound Recording"),
          trailing: PlayButton(
            filepath: state.value,
            isEnabled: state.value != null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: RecordButton(
            onRecord: (SafeFile file) {
              state.didChange(file.path);
            },
          ),
        )
      ],
    );
  }
}
