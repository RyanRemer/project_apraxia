import 'package:flutter/material.dart';
import 'package:project_apraxia/widget/Conditional.dart';

class PageNavigation extends StatelessWidget {
  final PageController pageController;
  final bool isFirst;
  final bool isLast;
  PageNavigation(
    this.pageController, {
    Key key,
    this.isFirst = false,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Conditional(
            condition: isFirst,
            childIfTrue: Container(),
            childIfFalse: RaisedButton(
                child: Text("Previous"),
                onPressed: () {
                  pageController.previousPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.linearToEaseOut);
                }),
          ),
          Conditional(
            condition: isLast,
            childIfTrue: RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text("Done", style: TextStyle(color: Colors.white)),
              onPressed: null, //TODO: go to result page
            ),
            childIfFalse: RaisedButton(
                child: Text("Next"),
                onPressed: () {
                  pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.linearToEaseOut);
                }),
          )
        ],
      ),
    );
  }
}
