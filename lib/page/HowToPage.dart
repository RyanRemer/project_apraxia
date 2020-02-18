import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';


class HowToPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("How To"),
        // automaticallyImplyLeading: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("About Appraxia", style: Theme.of(context).textTheme.title),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Appraxia is a tool to help determine the Word Syllable Duration (or WSD) of"
                      " an individual. This measurement can be used in the process of diagnosing"
                      " speech and language disabilities such as Aphasia and Apraxia of Speech (or AoS)"
                      ". For more information, see ",
                  style: Theme.of(context).textTheme.body1,
                ),
                TextSpan(
                  text: "here",
                  style: Theme.of(context).textTheme.body1,
                  recognizer: new TapGestureRecognizer() ..onTap = () async {
                    await launch("https://scholarsarchive.byu.edu/facpub/3251/");
                  }
                ),
                TextSpan(
                  text: ".",
                  style: Theme.of(context).textTheme.body1,
                )
              ]
            )
          ),
          Divider(),
          Text("How to take a WSD Test", style: Theme.of(context).textTheme.title),
          Text(""),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Measure the Ambiant noise level of the room", style: Theme.of(context).textTheme.body2)
          ),
          Text("On the first page of the test, remain as quiet as possible and press the record button."
              " Wait for 3 seconds while the recorder measures the ambiant noise level of the room to better"
              " calculate the users WSD.", style: Theme.of(context).textTheme.body1),
          Text(""), // This is basically just a divider without a line
          Align(
              alignment: Alignment.centerLeft,
              child: Text("Record the best attempt at speaking the prompted words", style: Theme.of(context).textTheme.body2)
          ),
        ]
      )
    );
  }
}