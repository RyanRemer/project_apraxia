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
    if (prompts == null || prompts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("No prompts found in save file"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.refresh),
              label: Text("Reload Assets"),
              onPressed: () async {
                List<Prompt> reloadedPrompts =
                    await promptController.reloadPrompts();
                setState(() {
                  prompts = reloadedPrompts;
                });
              },
            ),
          ],
        ),
      );
    }

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
                onChanged: canToggle(prompt)
                    ? (bool value) {
                        setState(() {
                          return prompt.enabled = value;
                        });
                        save();
                      }
                    : null,
              ),
              title: Text(prompt.word),
              trailing: PlayButton(
                filepath: prompt.soundUri,
              ),
              onLongPress: () => editPrompt(prompt),
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

  bool canToggle(Prompt prompt) {
    if (prompt.enabled == false) {
      return true;
    } else {
      return prompts.where((prompt) => prompt.enabled).length > 1;
    }
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
    Prompt prompt =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CustomPromptForm(
          prompt:
              new Prompt(soundUri: "prompts/prompt-${prompts.length + 1}.wav"));
    }));

    if (prompt != null) {
      setState(() {
        prompts.add(prompt);
      });
      save();
    }
  }

  Future<void> editPrompt(Prompt prompt) async {
    Prompt editedPrompt =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CustomPromptForm(prompt: prompt);
    }));

    if (editedPrompt != null) {
      setState(() {
        prompt = editedPrompt;
      });
      save();
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
