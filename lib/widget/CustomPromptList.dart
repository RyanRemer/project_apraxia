import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/PromptController.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/widget/PlayButton.dart';
import 'package:project_apraxia/widget/form/CustomPromptForm.dart';

class CustomPromptsList extends StatefulWidget {
  final List<Prompt> prompts;
  CustomPromptsList({@required this.prompts, key}) : super(key: key);

  @override
  _CustomPromptsListState createState() =>
      _CustomPromptsListState(this.prompts);
}

class _CustomPromptsListState extends State<CustomPromptsList> {
  PromptController promptController = new PromptController();
  List<Prompt> prompts;

  _CustomPromptsListState(this.prompts);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.only(bottom: 64.0),
        itemCount: prompts.length,
        itemBuilder: (BuildContext context, int index) {
          Prompt prompt = prompts[index];
          return Dismissible(
            key: ObjectKey(prompt),
            confirmDismiss: (direction) => confirmDelete(prompt),
            onDismissed: (direction) {
              setState(() {
                prompts.remove(prompt);
              });
              save();
            },
            child: ListTile(
              leading: Checkbox(
                value: prompt.enabled,
                onChanged: (bool value) {
                  setState(() {
                    return prompt.enabled = value;
                  });
                  save();
                },
              ),
              title: Text(prompt.word),
              trailing: PlayButton(
                filepath: prompt.soundUri,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("Prompt"),
        onPressed: addPrompt,
      ),
    );
  }

  Future<bool> confirmDelete(Prompt prompt) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirm Deletion"),
            content: Text(
              "Are you sure you want to delete the prompt for ${prompt.word}?",
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context, false),
              ),
              RaisedButton(
                child: Text("Delete"),
                onPressed: () => Navigator.pop(context, true),
              )
            ],
          );
        });
  }

  Future<void> addPrompt() async {
    Prompt prompt = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return CustomPromptForm(prompt: new Prompt());
    }));

    if (prompt != null){
      setState(() {
        prompts.add(prompt);
      });
    }
  }

  Future<void> save() async {
    try {
      await promptController.savePrompts(prompts);
    } catch (error) {
      throw (error);
    }
  }
}
