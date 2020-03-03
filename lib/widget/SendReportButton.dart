import 'package:flutter/material.dart';
import 'package:project_apraxia/widget/ReportDialog.dart';

class SendReportButton extends StatefulWidget {
  final String evalId;

  SendReportButton({Key key, @required this.evalId}) : super(key: key);

  @override
  _SendReportButtonState createState() => _SendReportButtonState();
}

class _SendReportButtonState extends State<SendReportButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.send),
      onPressed: () async => await promptForInfo(context),
    );
  }

  Future<void> promptForInfo(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return ReportDialog(evalId: widget.evalId);
        }
    );
  }


}
