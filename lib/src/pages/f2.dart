import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool showList;
  final List<String> options;
  final Function(String) onChanged;
  final Function(String) handleSelection;
  final Function(String) validator;

  const CustomTextField({
    required this.controller,
    required this.labelText,
    required this.showList,
    required this.options,
    required this.onChanged,
    required this.handleSelection,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: labelText),
      //validator: validator,
      // Otros atributos personalizables, como validadores y más
    );
  }
}
