import 'package:flutter/material.dart';

class TextformfieldView extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Icon icon;
  final String? Function(String?) validatorCallback;
  final TextEditingController textEditingController;
  final bool obscureText;

  const TextformfieldView({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.icon,
    required this.validatorCallback,
    required this.obscureText,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        cursorColor: Colors.orange,
        cursorHeight: 20,
        obscureText: obscureText,
        controller: textEditingController,
        validator: validatorCallback,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          filled: true,
          label: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              labelText,
              style: const TextStyle(color: Colors.orange, fontSize: 15),
            ),
          ),
          contentPadding: const EdgeInsets.only(left: 20),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          suffixIcon: icon,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.orange),
          ),
        ));
  }
}
