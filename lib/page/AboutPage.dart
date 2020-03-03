import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width > 500 ? 500 : MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("About APPraxia"),
        // automaticallyImplyLeading: true,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: screenWidth,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Background", style: Theme.of(context).textTheme.body2)
                  ),
                  Text(""),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "APPraxia was developed by a team comprising researchers at the ",
                            style: Theme.of(context).textTheme.body1,
                          ),
                          TextSpan(
                            text: "BYU Aphasia and Speech Learning (BASL) Lab",
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              launch('http://aphasia.byu.edu');
                            },
                          ),
                          TextSpan(
                            text: " and undergraduate Computer Science students from Brigham Young University.",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(""),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("It was developed with two goals in mind:")
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text("1. Provide a data-driven diagnosis for Apraxia of Speech (AOS)."),
                      )
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text("2. Provide a quantitative measurement for tracking the progress of patients with AOS."),
                      )
                  ),
                  Text(""),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Word Syllable Duration and the Test", style: Theme.of(context).textTheme.body2)
                  ),
                  Text(""),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Word Syllable Duration (WSD) is a metric calculated by measuring the time (in "
                                  "milliseconds) it takes a patient to say a word and dividing that time by the number of "
                                  "syllables in the word. Researchers at the BASL Lab have found that WSD measurements recorded "
                                  "during a brief test consisting of ten multi-syllabic words are strongly correlated with the "
                                  "presence of AOS. Read more about their research ",
                            style: Theme.of(context).textTheme.body1,
                          ),
                          TextSpan(
                            text: "here",
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              launch('http://aphasia.byu.edu/publications-presentations/');
                            },
                          ),
                          TextSpan(
                            text: ".",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(""),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Study Participation", style: Theme.of(context).textTheme.body2)
                  ),
                  Text(""),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("APPraxia was developed to assist the researchers at the BASL Lab and provide a "
                          "larger sample size for their study of the effectiveness of the WSD measurement in "
                          "predicting AOS. If a test is conducted using \"Local Processing\", then no data "
                          "will be shared with researchers. However, if a test is conducted using \"Advanced "
                          "Processing\", then, in addition to more accurate results, data will be sent securely "
                          "to registered researchers for further analysis and potential inclusion in the IRB "
                          "registered study.",
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                  Text(""),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("HIPAA Compliance", style: Theme.of(context).textTheme.body2)
                  ),
                  Text(""),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("In accordance with the legal requirements in the United States of America, this study "
                      "requires that all Protected Health Information is protected. If \"Advanced Processing\" is used, "
                      "patients (or legal representatives) will be required to have a digitally signed HIPAA waiver on file to proceed. This waiver "
                      "grants researchers access to the patient's recordings, WSD calculations, and the answers to a "
                      "brief demographic survey at the beginning of the test. Both the patient and the owner of the "
                      "APPraxia account (likely the clinician) will receive a signed copy of this waiver via email.",
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                  Text(""),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("All recordings, except those reported to researchers, will be deleted upon completion"
                        " of the test and will be unaccessible.",
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                ]
              ),
            ),
          ),
        ),
      )
    );
  }
}