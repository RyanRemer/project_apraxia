import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/PromptController.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/widget/CustomPromptList.dart';

class CustomPromptLoader extends StatelessWidget {
  final PromptController promptController = new PromptController();

  CustomPromptLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: promptController.getPrompts(),
      builder: (BuildContext context, AsyncSnapshot<List<Prompt>> snapshot) {
        if (snapshot.hasData) {
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
