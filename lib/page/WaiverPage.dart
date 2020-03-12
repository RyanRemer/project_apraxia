import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_apraxia/page/SignWaiverPage.dart';
import 'package:flutter/services.dart' show rootBundle;

class WaiverPage extends StatefulWidget {
  WaiverPage({Key key}) : super(key: key);

  @override
  _WaiverPageState createState() => _WaiverPageState();
}

class _WaiverPageState extends State<WaiverPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HIPAA Waiver"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: loadWaiverInfo(), builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                else {
                  List<dynamic> hipaaData = snapshot.data;
                  return ListView.builder(
                    itemCount: hipaaData.length,
                    itemBuilder: (BuildContext context, int index) {
                    dynamic map = hipaaData[index];
                    if (map["text"] == null) {
                      return Divider();
                    }
                    TextStyle style;
                    if (map["style"] == "title") {
                      style = Theme.of(context).textTheme.title;
                    }
                    else if (map["style"] == "body1") {
                      style = Theme.of(context).textTheme.body1;
                    }
                    else if (map["style"] == "body2") {
                      style = Theme.of(context).textTheme.body2;
                    }
                    return Padding(
                      padding: new EdgeInsets.only(
                        top: map["top_margin"],
                        bottom: map["bot_margin"],
                        right: map["right_margin"],
                        left: map["left_margin"],
                      ),
                      child: Text(map["text"], style: style),
                    );
                  });
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ButtonBar(
              children: <Widget>[
                RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Sign Waiver"),
                  ),
                  onPressed: () => _goToSignWaiverPage(context),
                ),
              ],
            )
          )
        ],
      )
    );
  }

  Future<List<dynamic>> loadWaiverInfo() async {
    String jsonString = await rootBundle.loadString('assets/hipaa_waiver.json');
    return jsonDecode(jsonString);
  }

  void _goToSignWaiverPage(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return SignWaiverPage();
    }));
  }

}
