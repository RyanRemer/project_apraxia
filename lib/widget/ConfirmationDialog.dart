
import 'package:flutter/material.dart';

class ConfirmationDialog {
  BuildContext context;
  ConfirmationDialog(this.context);

  Future<bool> show(String title, String content) async {
    bool confirmed = await showDialog<bool>(context: this.context, builder: (context){
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          RaisedButton(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Confirm"),
            ),
            onPressed: () => Navigator.pop(context, true),
          )
        ],
      );
    });

    //if the user dismisses dialog
    if (confirmed == null){
      return false;
    }

    return confirmed;
  }
}