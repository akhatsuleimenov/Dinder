import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String text;

  const CustomTextField({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: text,
        contentPadding: const EdgeInsets.only(
          bottom: 5,
          top: 15,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
