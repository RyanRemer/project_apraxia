import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/widget/form_field/RecordingFormField.dart';

class CustomPromptForm extends StatefulWidget {
  final Prompt prompt;
  CustomPromptForm({@required this.prompt, key}) : super(key: key);

  @override
  _CustomPromptFormState createState() => _CustomPromptFormState(this.prompt);
}

class _CustomPromptFormState extends State<CustomPromptForm> {
  static final _formKey = new GlobalKey<FormState>();
  Prompt prompt;

  _CustomPromptFormState(this.prompt);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Prompt Form"),),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: TextFormField(
                initialValue: prompt.word,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: "Word"
                ),
                validator: (String value){
                  if (value.isEmpty){
                    return "Word must not be empty";
                  }
                  return null;
                },
                onSaved: (String value){
                  prompt.word = value;
                },
              ),
            ),
            ListTile(
              title: TextFormField(
                initialValue: prompt.syllableCount != null ? prompt.syllableCount.toString() : null,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  labelText: "Syllable Count"
                ),
                validator: (String value){
                  if (value.isEmpty){
                    return "You must enter a number";
                  }
                  if (int.tryParse(value) == null){
                    return "Enter a valid number";
                  }
                  return null;
                },
                onSaved: (String value){
                  prompt.syllableCount = int.parse(value);
                },
              ),
            ),
            RecordingFormField(
              filePath: prompt.soundUri,
              validator: (String path){
                if (File(path).existsSync() == false){
                  return "File to recording not found";
                }
                return null;
              },
              onSaved: (String path){
                prompt.soundUri = path;
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.check),
        label: Text("Submit"),
        onPressed: () {
          if (_formKey.currentState.validate()){
            _formKey.currentState.save();
            Navigator.pop(context, prompt);
          }
        },
      ),
    );
  }
}