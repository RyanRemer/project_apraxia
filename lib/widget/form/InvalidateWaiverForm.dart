import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/widget/ErrorDialog.dart';
import 'package:project_apraxia/widget/form/WaiverSearchForm.dart';

class InvalidateWaiverForm extends StatefulWidget {

  InvalidateWaiverForm({Key  key}) : super(key: key);

  @override
  _InvalidateWaiverFormState createState() => _InvalidateWaiverFormState();
}

class _InvalidateWaiverFormState extends State<InvalidateWaiverForm> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        WaiverSearchForm(onSelect: onWaiverSelected)
      ],
    );
  }
  
  void onWaiverSelected(Map<String, String> waiver, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Waiver Invalidation"),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("I, ${waiver['subjectName']}, certify that I invalidate the HIPAA waiver with the following information and revoke researchers\' future access to my data."),
              Text(""),
              Text("Name: ${waiver['subjectName']}"),
              Text("Email: ${waiver['subjectEmail']}"),
              Text("Date Signed: ${waiver['date']}")
            ]
        ),
        actions: <Widget>[
          FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              }
          ),
          RaisedButton(
            child: Text("Confirm"),
            onPressed: () async {
              bool res = await invalidateWaiver(waiver["waiverId"]);
              if (res) {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Success"),
                    content: Text("The waiver for ${waiver['subjectName']} has been successfully invalidated."),
                    actions: <Widget>[
                      RaisedButton(
                        child: Text("Ok"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }
                      )
                    ],
                  )
                );
              }
            }
          )
        ],
      ),
    );
  }

  Future<bool> invalidateWaiver(String waiverId) async {
    HttpConnector connector = new HttpConnector.instance();
    try {
      await connector.invalidateWaiver(waiverId);
      return true;
    } on ServerConnectionException {
      ErrorDialog dialog = new ErrorDialog(context);
      dialog.show('Error Connecting to Server', 'Please try again later.');
    } on InternalServerException catch (e) {
      ErrorDialog dialog = new ErrorDialog(context);
      dialog.show('Internal Server Error', e.message);
    }
    return false;
  }
}
