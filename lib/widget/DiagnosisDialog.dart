import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DiagnosisDialog {
  BuildContext context;

  DiagnosisDialog(this.context);

  void show(double wsd) {
    showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: Text("Diagnosis Suggestion"),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 16.0),
            child: Text(getDiagnosisText(wsd)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                RaisedButton(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.link),
                      Text(" View Research"),
                    ],
                  ),
                  onPressed: () {
                    launch("https://pubs.asha.org/doi/abs/10.1044/2018_AJSLP-MSC18-18-0107");
                  },
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  String getDiagnosisText(double wsd){
    if (wsd > 320){
      return "A WSD that is above 320 suggests that the subject is likely to have apraxia of speech.";
    }
    else {
      return "A WSD that is below 320 suggests that the subject does not have apraxia of speech.";
    }
  }
}