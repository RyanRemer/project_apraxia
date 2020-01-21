import 'package:flutter/material.dart';
import 'package:project_apraxia/data/WsdReport.dart';

class ReportsPage extends StatefulWidget {
  final WsdReport wsdReport;

  ReportsPage(this.wsdReport, {Key key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState(this.wsdReport);
}

class _ReportsPageState extends State<ReportsPage> {
  WsdReport wsdReport;
  bool loading;

  _ReportsPageState(WsdReport wsdReport) {
    this.wsdReport = wsdReport;
    loading = false;
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
            body: Column(children: [
              Table(children: [
                TableRow(children: [Text("Word"), Text("Calculated WSD")]),
                TableRow(children: [Text("Gingerbread"), Text("320")]),
                TableRow(children: [
                  Text("Constitution"),
                  Text("320"),
                ]),
                TableRow(children: [Text("Flattering"), Text("320")]),
                TableRow(children: [
                  Text("Harmonica"),
                  Text("320"),
                ]),
                TableRow(children: [Text("Jabbering"), Text("320")]),
                TableRow(children: [
                  Text("Spaghetti"),
                  Text("320"),
                ]),
                TableRow(children: [Text("Stethoscope"), Text("320")]),
                TableRow(children: [
                  Text("Thickening"),
                  Text("320"),
                ]),
                TableRow(children: [Text("Volcano"), Text("320")]),
                TableRow(children: [
                  Text("Zippering"),
                  Text("320"),
                ])
              ])
            ]));
  }
}
