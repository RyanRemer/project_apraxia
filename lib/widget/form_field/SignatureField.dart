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
    return Column(
      children: <Widget>[
        state.hasError
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  state.errorText,
                  style: TextStyle(color: Colors.red),
                ),
              )
            : Container(),
        state.value != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Image.file(
                    new File(state.value),
                  ),
                  onTap: () => sign(context),
                ),
              )
            : RaisedButton(
                child: Text("Sign"),
                onPressed: () => sign(context),
              ),
      ],
    );
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
