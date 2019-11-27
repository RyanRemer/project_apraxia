import 'package:flutter/material.dart';
typedef ChangeListener<T> = void Function(T value);

class ObservedValue<T> extends ValueNotifier<T>{
  ObservedValue(T value) : super(value);

  get value {
    return super.value;
  }

  set value(T value){
    super.value = value;
  }

  void addValueListener(ChangeListener<T> listener){
    super.addListener((){
      listener(super.value);
    });
  }
}