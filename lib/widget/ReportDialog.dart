import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/FormValidator.dart';
import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/widget/ErrorDialog.dart';

class ReportDialog extends StatefulWidget {
  final String evalId;
  ReportDialog({Key key, @required this.evalId}): super(key: key);

  @override
  _ReportDialogState createState() => new _ReportDialogState();
}


class _ReportDialogState extends State<ReportDialog> {
  final HttpConnector _connector = new HttpConnector.instance();
  static GlobalKey<FormState> _formKey = new GlobalKey();
  String _name = "";
  String _email;
  bool _loading = false;

  @override
  void initState(){
    super.initState();
  }

  _getContent(){
    return AlertDialog(
      title: _loading ? Text("Sending Report") : Text("Enter name and email"),
      content: _loading ? SizedBox(
        child: Center(
          child: Padding(
              padding: EdgeInsets.all(26.0),
              child: CircularProgressIndicator()
          ),
          heightFactor: 1.0,
        ),
      ): Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget> [
                Text("Enter the name of the patient and the clinician's email. A PDF report containing information from this evaluation will be sent to the email."),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Patient Name (optional)",
                      hintText: "First Last"
                  ),
                  controller: TextEditingController(text: _name),
                  onChanged: (String value) {
                    _name = value;
                  },
                  validator: (String value) {
                    if (value == "") {
                      return null;
                    }
                    return FormValidator.isValidName(value);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "email@example.com"
                  ),
                  onChanged: (String value) {
                    _email = value;
                  },
                  validator: (String value) {
                    return FormValidator.isValidEmail(value);
                  },
                ),
              ]
          )
      ),
      actions: _loading ? <Widget>[] : <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Send Report'),
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                sendReport(context, _email, _name, widget.evalId);
                _email = null;
                _name = "";
              }
            }
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }

  Future sendReport(BuildContext context, String email, String name, String evalId) async {
    try {
      setState(() {
        _loading = true;
      });
      await _connector.sendReport(email, name, evalId);
      Navigator.of(context).pop();
      setState(() {
        _loading = false;
      });
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text("Success"),
                content: Text("An email containing a PDF report of this evaluation was sent to " + email + "."),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              )
      );
    } on InternalServerException catch (e) {
      setState(() {
        _loading = false;
      });
      ErrorDialog dialog = new ErrorDialog(context);
      dialog.show("Internal Server Error", e.message + "\n\nPlease try again. If the problem persists, please record the information manually.");
    } on ServerConnectionException {
      setState(() {
        _loading = false;
      });
      ErrorDialog dialog = new ErrorDialog(context);
      dialog.show("Error Conecting to Server", "Please try again. If the problem persists, please record the information manually.");
    } on Exception {
      setState(() {
        _loading = false;
      });
      ErrorDialog dialog = new ErrorDialog(context);
      dialog.show("Unknown Error", "An unknown error occurred while sending the report. Please try again. If the problem persists, please record the information manually.");
    }
  }
}