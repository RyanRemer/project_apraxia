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

  _ReportsPageState(this.wsdReport);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports Page"),
      ),
      body: Center(child: Text("Reports Page"))
    );
  }

}
