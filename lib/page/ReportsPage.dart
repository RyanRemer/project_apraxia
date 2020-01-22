import 'package:flutter/material.dart';
import 'package:project_apraxia/data/WsdReport.dart';
import 'package:project_apraxia/model/Attempt.dart';
import 'package:project_apraxia/model/Prompt.dart';

class ReportsPage extends StatefulWidget {
  final WsdReport wsdReport;
  final List<Prompt> prompts;

  ReportsPage(this.wsdReport, this.prompts, {Key key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState(this.wsdReport, this.prompts);
}

class _ReportsPageState extends State<ReportsPage> {
  WsdReport wsdReport;
  bool loading;
  List<Prompt> prompts;
  Map<Prompt, Attempt> calculatedWSDs;

  _ReportsPageState(WsdReport wsdReport, List<Prompt> prompts) {
    this.wsdReport = wsdReport;
    this.prompts = prompts;
    loading = false;
    calculatedWSDs = new Map();

    for (final prompt in prompts) {
      calculatedWSDs[prompt] = new Attempt("", 0.0);
    }
  }

  @override
  void initState() {
    super.initState();
    calculateWSDs();
  }

  void calculateWSDs() {
    setState(() {
      loading = true;
    });
    Future.delayed(new Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
            appBar: AppBar(
              title: Text("Reports Page"),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  CircularProgressIndicator(),
                  Text("Loading Reports...")
                ])))
        : Scaffold(
            appBar: AppBar(
              title: Text("Reports Page"),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: ListView.builder(
                    itemBuilder: (context, position) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(prompts[position].word),
                              Text(calculatedWSDs[prompts[position]].WSD.toString())
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: prompts.length,
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Average WSD", style: TextStyle(fontSize: 24)),
                        ),
                        Text("320.0", style: TextStyle(fontSize: 36),),
                      ],
                    )
                ),
                RaisedButton(
                  child: Text("Complete Test"),
                  onPressed: null,
                )
              ],
            ));
  }
}
