import 'package:flutter/material.dart';


class HowToPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width > 500 ? 500 : MediaQuery.of(context).size.width;
    final double imageWidth = screenWidth * 0.65;
    final double imageHeight = imageWidth * 1.7;
    return Scaffold(
      appBar: AppBar(
        title: Text("How To"),
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
                      " calculation.", style: Theme.of(context).textTheme.body1),
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
                        top: imageHeight * 0.025,
                        right: imageWidth * 0.046,
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
                        left: imageWidth * 0.049,
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
                        right: imageWidth * 0.046,
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
                        bottom: imageHeight * 0.0125,
                        right: imageWidth * 0.07,
                        child: Tooltip(
                          message: "Moves to the next prompt",
                          preferBelow: false,
                          child: Container(
                            height: imageWidth * 0.15,
                            width: imageWidth * 0.15,
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
                        bottom: imageHeight * 0.0125,
                        right: imageWidth * 0.07,
                        child: Tooltip(
                          message: "Moves to the previous prompt",
                          preferBelow: false,
                          child: Container(
                            height: imageWidth * 0.15,
                            width: imageWidth * 0.15,
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
                  ),
                  Text(""),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Recording the results", style: Theme.of(context).textTheme.body2)
                  ),
                  Text(""),
                  Text("When you complete a test, there are two options for you to record your results:", style: Theme.of(context).textTheme.body1),
                  Text(""),
                  Text("\t 1) If you or your patient signed a waiver, the results will be stored on a secure server for you"
                      " to access at another time from the main menu"),
                  Text(""),
                  Text("\t 2) If you or your patient opted not to sign a waiver, then no data is recorded in the app, and you"
                      " will need to write it down in order to save it.")
                ]
              ),
            ),
          ),
        ),
      )
    );
  }
}