import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormField extends FormField<DateTime> {
  DateFormField({
    DateTime initialValue,
    @required DateTime firstDate,
    @required DateTime lastDate,
    FormFieldSetter<DateTime> onSaved,
    FormFieldValidator<DateTime> validator,
  }) : super(
            initialValue: initialValue,
            validator: validator,
            onSaved: onSaved,
            builder: (FormFieldState<DateTime> state) {
              return _DateFormField(state, firstDate, lastDate);
            });
}

class _DateFormField extends StatelessWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final FormFieldState<DateTime> state;
  final DateFormat dateFormat = new DateFormat("MMMM dd, yyyy");

  _DateFormField(this.state, this.firstDate, this.lastDate);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(dateFormat.format(state.value)),
      subtitle: state.hasError
          ? Text(state.errorText, style: TextStyle(color: Colors.red))
          : null,
      trailing: Icon(Icons.calendar_today),
      onTap: () => pickDate(context),
    );
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: state.value,
        firstDate: firstDate,
        lastDate: lastDate);
    if (picked != null) {
      state.didChange(picked);
    }
  }
}
