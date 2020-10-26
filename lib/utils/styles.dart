import 'package:flutter/material.dart';

InputDecoration getInputDecoration({hintText}) {
  return InputDecoration(
    hintText: "$hintText",
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    labelText: "$hintText",
  );
}