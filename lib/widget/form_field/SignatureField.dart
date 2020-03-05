import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_apraxia/page/SignaturePage.dart';

class SignatureField extends FormField<String> {
  SignatureField({
    @required String value,
    FormFieldValidator<String> validator,
    FormFieldSetter<String> onSaved,
  }) : super(
            initialValue: value,
            validator: validator,
            onSaved: onSaved,
            builder: (FormFieldState<String> state) {
              return _SignatureFormField(state);
            });
}

class _SignatureFormField extends StatelessWidget {
  final FormFieldState<String> state;

  _SignatureFormField(this.state);

  @override
  Widget build(BuildContext context) {
    if (state.hasError) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              state.errorText,
              style: TextStyle(color: Colors.red),
            ),
          ),
          RaisedButton(
            child: Text("Sign Again"),
            onPressed: () => sign(context),
          ),
        ],
      );
    }
    if (state.value != null) {
      return Image.file(new File(state.value));
    } else {
      return RaisedButton(
        child: Text("Sign"),
        onPressed: () => sign(context),
      );
    }
  }

  Future<void> sign(BuildContext context) async {
    String filePath =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new SignaturePage(
          filePrefix: new DateTime.now().toIso8601String());
    }));
    if (filePath != null) {
      state.didChange(filePath);
    }
  }
}
