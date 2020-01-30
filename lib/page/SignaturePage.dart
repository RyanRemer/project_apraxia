import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:project_apraxia/widget/ErrorDialog.dart';
import 'package:signature/signature.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SignaturePage extends StatefulWidget {
  SignaturePage({Key key}) : super(key: key);

  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  final SignatureController _controller = SignatureController(penStrokeWidth: 3, penColor: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Electronic Signature"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Electronic Signature", style: Theme.of(context).textTheme.title),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Sign in the gray area below.", style: Theme.of(context).textTheme.body2),
          ),
          Signature(controller: _controller, backgroundColor: Colors.black26, width: _getCanvasWidth(), height: _getCanvasHeight(),),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "By submitting a signature, you acknowledge that you have signed the agreement and authorize the use of this digital signature in place of a physical one.",
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Spacer(),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text("Clear Canvas"),
                onPressed: _clearCanvas,
              ),
              FlatButton(
                child: Text("Submit Signature"),
                onPressed: _submitSignature,
              )
            ],
          )
        ],
      ),
    );
  }

  Future<File> _saveSignature(Uint8List bytes) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dirPath = directory.path;
    File file = new File('$dirPath/signature.png');
    return file.writeAsBytes(bytes);
  }

  void _submitSignature() async {
    if (_controller.isNotEmpty) {
      Uint8List pngBytes = await _controller.toPngBytes();
      File file = await _saveSignature(pngBytes);
      Navigator.pop(context, file.path);
    }
    else {
      ErrorDialog errorDialog = new ErrorDialog(context);
      errorDialog.show("Empty Signature",
          "The signature canvas cannot be blank. Please sign again.");
    }
  }

  void _clearCanvas() async {
    setState(() => _controller.clear());
  }

  double _getCanvasWidth() {
    return MediaQuery.of(context).size.width * 0.8;
  }

  double _getCanvasHeight() {
    return MediaQuery.of(context).size.height * 0.2;
  }
}
