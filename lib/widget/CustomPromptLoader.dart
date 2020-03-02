import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/PromptController.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/widget/CustomPromptList.dart';

class CustomPromptLoader extends StatefulWidget {
  CustomPromptLoader({Key key}) : super(key: key);

  @override
  _CustomPromptLoaderState createState() => _CustomPromptLoaderState();
}

class _CustomPromptLoaderState extends State<CustomPromptLoader> {
  final promptController = new PromptController();
  Future<List<Prompt>> promptFuture;

  _CustomPromptLoaderState() {
    promptFuture = promptController.getPrompts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: promptFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Prompt>> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Error loading prompts"),
                ),
                FlatButton.icon(
                    icon: Icon(Icons.refresh),
                    label: Text("Reload Assets"),
                    onPressed: () async {
                      List<Prompt> reloadedPrompts =
                          await promptController.reloadPrompts();
                      await promptController.savePrompts(reloadedPrompts);
                      setState(() {
                        promptFuture = promptController.getPrompts();
                      });
                    }),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          return CustomPromptsList(
            prompts: snapshot.data,
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
