import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';


class HowToPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageWidth = screenWidth * 0.65;
    final double imageHeight = imageWidth * 1.7;
    return Scaffold(
      appBar: AppBar(
        title: Text("How To"),
        // automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("About Appraxia", style: Theme.of(context).textTheme.title),
              Text(""),
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
              Text(""),
              Divider(),
              Text(""),
              Text("How to take a WSD Test", style: Theme.of(context).textTheme.title),
              Text(""),
              Text(""),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Measure the Ambiant noise level of the room", style: Theme.of(context).textTheme.body2)
              ),
              Text(""),
              Text("On the first page of the test, remain as quiet as possible and press the record button."
                  " Wait for 3 seconds while the recorder measures the ambiant noise level of the room to better"
                  " calculate an average WSD.", style: Theme.of(context).textTheme.body1),
              Text(""), // This is basically just a divider without a line
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Recording each word", style: Theme.of(context).textTheme.body2)
              ),
              Text(""),
              Text("In this section of the test, record the word displayed. If the word needs to be spoken allowed,"
                  " a pre-recorded prompt can be played. If the first attempt is unsuccessful, simply tap the record"
                  " button to record another attempt, then select which recording will be used as part of the WSD"
                  " calculation."),
              Text(""),
              Text("Tap and hold on a circle for more information about what that item does."),
              Text(""),
              Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      )
                    ),
                    child: Image(
                      image: AssetImage('assets/help/recording_page.png'),
                      width: imageWidth,
                      height: imageHeight,
                    ),
                  ),
                  Positioned(
                    top: imageHeight * 0.0275,
                    right: imageWidth * 0.0475,
                    child: Tooltip(
                      message: "Plays someone speaking the prompt for the word",
                      preferBelow: false,
                      child: Container(
                        height: imageWidth * 0.1,
                        width: imageWidth * 0.1,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.redAccent,
                              width: 2.5
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: imageHeight * 0.14,
                    left: imageWidth * 0.0525,
                    child: Tooltip(
                      message: "Selects the best recording",
                      preferBelow: false,
                      child: Container(
                        height: imageWidth * 0.1,
                        width: imageWidth * 0.1,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.redAccent,
                              width: 2.5
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: imageHeight * 0.14,
                    right: imageWidth * 0.0475,
                    child: Tooltip(
                      message: "Plays the recording of attempt",
                      preferBelow: false,
                      child: Container(
                        height: imageWidth * 0.1,
                        width: imageWidth * 0.1,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.redAccent,
                              width: 2.5
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: imageHeight * 0.005,
                    right: imageWidth * 0.0475,
                    child: Tooltip(
                      message: "Moves to the next prompt",
                      preferBelow: false,
                      child: Container(
                        height: imageWidth * 0.2,
                        width: imageWidth * 0.2,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.redAccent,
                              width: 2.5
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ]
          ),
        ),
      )
    );
  }
}