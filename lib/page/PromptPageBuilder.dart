import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/PromptController.dart';
import 'package:project_apraxia/model/Prompt.dart';
import 'package:project_apraxia/page/PromptPage.dart';

/// [PromptPageBuilder] is a widget that uses a [PageView] to build a [PromptPage] for each [Prompt]
class PromptPageBuilder extends StatefulWidget {
  final List<Prompt> prompts;
  PromptPageBuilder(this.prompts, {Key key}) : super(key: key);

  @override
  _PromptPageBuilderState createState() => _PromptPageBuilderState(this.prompts);
}

class _PromptPageBuilderState extends State<PromptPageBuilder> {
  PageController pageController;
  List<Prompt> prompts;
  PromptController promptController;

  _PromptPageBuilderState(this.prompts) {
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
