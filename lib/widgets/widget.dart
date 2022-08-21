import 'package:flutter/material.dart';

TextFormField textFormField({
  @required TextEditingController controller,
  String hint,
  String label,
}) =>
    TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
      ),
    );
