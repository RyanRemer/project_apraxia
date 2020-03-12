import 'package:flutter/material.dart';

class ErrorDialog {
  BuildContext context;
  ErrorDialog(this.context);

  Future show(String title, String content){
    return showDialog(context: this.context, builder: (context){
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text("Okay"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      );
    });
  }
}