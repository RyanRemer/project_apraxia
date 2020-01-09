import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/PromptController.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/widget/PageNavigation.dart';
import 'package:project_apraxia/widget/PromptTile.dart';
import 'package:project_apraxia/widget/RecordButton.dart';

class PromptPage extends StatefulWidget {
  final Prompt prompt;
  final PageController pageController;

  PromptPage(this.prompt, this.pageController, {Key key}) : super(key: key);

  @override
  _PromptPageState createState() =>
      _PromptPageState(this.prompt, this.pageController);
}

class _PromptPageState extends State<PromptPage> {
  Prompt prompt;
  PageController pageController;
  PromptController promptController = new PromptController();

  _PromptPageState(this.prompt, this.pageController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          PromptTile(prompt),
          Expanded(
            child: Center(
              child: RecordButton(onRecord: (File soundFile) {
                print(soundFile.path);
              },),
            ),
          ),
          PageNavigation(
            pageController,
            isFirst: promptController.isFirst(prompt),
            isLast: promptController.isLast(prompt),
          )
        ],
      ),
    );
  }
}
