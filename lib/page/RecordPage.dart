import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/PromptController.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/page/PromptPages.dart';
import 'package:project_apraxia/widget/RecordButton.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  PromptController promptController = new PromptController();
  Future<List<Prompt>> promptsFuture;

  _RecordPageState() {
    promptsFuture = promptController.getPrompts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: promptsFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return _buildErrorPage(snapshot.error);
        } else if (snapshot.connectionState != ConnectionState.done) {
          return _buildPromptsLoading();
        } else {
          return PromptPages(snapshot.data);
        }
      },
    );
  }

  Widget _buildPromptsLoading() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text("Loading Prompts..."),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPage(error) {
    return Scaffold(
      body: Center(
        child: Text(error),
      ),
    );
  }
}
