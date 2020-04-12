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
          ListTile(
            title: Text(getDiagnosisText(wsd)),
          ),
          ListTile(
            leading: Icon(Icons.link),
            title: Text("View Research"),
            trailing: Icon(Icons.arrow_forward),
            onTap: (){
              launch("https://pubs.asha.org/doi/abs/10.1044/2018_AJSLP-MSC18-18-0107");
            },
          ),
        ],
      );
    });
  }

  String getDiagnosisText(double wsd){
    if (wsd > 320){
      return "A WSD that is above 320 suggests that the subject is likely to have apraxia of speach.";
    }
    else {
      return "A WSD that is below 320 suggests that the subject does not have apraxia of speach.";
    }
  }
}