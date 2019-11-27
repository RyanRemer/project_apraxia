import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/PromptController.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/page/PromptPage.dart';

/// [PromptPages] is a widget that uses a [PageView] to build a [PromptPage] for each [Prompt]
class PromptPages extends StatefulWidget {
  List<Prompt> prompts;
  PromptPages(this.prompts, {Key key}) : super(key: key);

  @override
  _PromptPagesState createState() => _PromptPagesState(this.prompts);
}

class _PromptPagesState extends State<PromptPages> {
  PageController pageController;
  List<Prompt> prompts;
  PromptController promptController;

  _PromptPagesState(this.prompts) {
    pageController = new PageController();
    promptController = new PromptController();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
          controller: pageController,
          itemCount: prompts.length,
          itemBuilder: (BuildContext context, int index) {
            return PromptPage(prompts[index], pageController, key: ObjectKey(prompts[index]),);
          },
        );
  }
}
