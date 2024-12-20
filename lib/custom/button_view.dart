import 'package:flutter/material.dart';

class ButtonView extends StatelessWidget {
  final String text;
  final VoidCallback voidCallback;
  const ButtonView({super.key, required this.text, required this.voidCallback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: voidCallback,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
